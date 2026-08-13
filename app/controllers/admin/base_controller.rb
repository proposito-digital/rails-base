class Admin::BaseController < ApplicationController
  include Pagy::Method
  include Translations::TranslationFlashMessages
  include SidebarConcerns
  include Pundit::Authorization

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  before_action :set_pagy_locale
  before_action :set_menu # SidebarConcerns
  before_action :set_model_class
  before_action :set_instance_and_authorize, only: %i[ show edit update destroy ]

  helper_method :filter_sort_column, :filter_sort_direction, :sortable_column?

  def pundit_user
    Current.user
  end

  # GET /admin instance/or /admin.instance/json
  def index
    scope = policy_scope(@model)
    scope = apply_term_filter(scope)
    scope = apply_sort(scope)

    @pagy, @instances = pagy(scope, limit: 10)
    authorize @model
  end

  # GET /admin/instance/1 or /admin/instance/1.json
  def show
  end

  # GET /admin/instance/new
  def new
    @instance = @model.new
    authorize @instance
  end

  # GET /admin/instance/1/edit
  def edit
  end

  # POST /admin instance/or /admin.instance/json
  def create
    @instance = @model.new(instance_params)
    authorize @instance

    respond_to do |format|
      if @instance.save
        format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
        format.json { render :show, status: :created, location: @instance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/instance/1 or /admin/instance/1.json
  def update
    respond_to do |format|
      if @instance.update(instance_params)
        format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
        format.json { render :show, status: :ok, location: @instance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/instance/1 or /admin/instance/1.json
  def destroy
    @instance.destroy!

    respond_to do |format|
      format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
      format.json { head :no_content }
    end
  end

  protected

    def underscore_model_class
      klass = @instance&.class || @model
      klass.model_name.element.pluralize
    end

  private

    def set_pagy_locale
      Pagy::I18n.locale = I18n.locale.to_s.tr("_", "-").sub(/-[a-z]{2}\z/) { |region| region.upcase }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_instance_and_authorize
      @instance = @model.find(params.expect(:id))
      authorize @instance
    end

    def redirect_to_index
      # Exemple: admin/dogs
      controller = params[:controller]
      namespace = controller.gsub("/", "_")
      # namespace = controller.gsub("/", "_")[6..]
      "#{namespace}_path"
    end

    def set_model_class
      candidates = model_class_candidates

      @model = candidates.lazy
        .map { |candidate| candidate.safe_constantize }
        .find(&:present?)

      raise NameError, "uninitialized constant #{candidates.first}" if @model.nil?
    end

    def model_class_candidates
      namespaced_model = params[:controller].to_s.classify

      [ namespaced_model, namespaced_model.demodulize ].uniq
    end

    def apply_term_filter(scope)
      term = params[:term].to_s.strip
      return scope if term.blank?

      columns = normalized_filter_columns
      return scope if columns.empty?

      quoted_table = @model.connection.quote_table_name(@model.table_name)
      normalized_term = "%#{term.downcase}%"

      conditions = columns.each_with_index.map do |column, index|
        quoted_column = @model.connection.quote_column_name(column)
        "LOWER(CAST(#{quoted_table}.#{quoted_column} AS TEXT)) LIKE :term_#{index}"
      end

      bindings = columns.each_index.to_h do |index|
        [ :"term_#{index}", normalized_term ]
      end

      scope.where(conditions.join(" OR "), bindings)
    end

    def normalized_filter_columns
      columns = filter_fields.map { |field| field.to_s.split(".").last }
      columns = columns.select { |column| @model.column_names.include?(column) }
      columns = columns.uniq

      columns.presence || default_filter_columns
    end

    def default_filter_columns
      @model.column_names - %w[ id deleted_at created_at updated_at password_digest ]
    end

    def filter_fields
      default_filter_columns
    end

    def apply_sort(scope)
      scope.reorder(filter_sort_column => filter_sort_direction)
    end

    def sortable_column?(column_name)
      normalized_sort_columns.include?(column_name.to_s)
    end

    def normalized_sort_columns
      @normalized_sort_columns ||= begin
        columns = sort_fields.map { |field| field.to_s.split(".").last }
        columns = columns.select { |column| @model.column_names.include?(column) }
        columns = columns.uniq

        columns.presence || default_sort_fields
      end
    end

    def default_sort_fields
      @model.column_names - %w[ id deleted_at password_digest ]
    end

    def sort_fields
      default_sort_fields
    end

    def filter_params
      params.permit(:term, :page, :sort_column, :sort_direction)
    end

    def filter_sort_column
      requested_column = filter_params[:sort_column].to_s
      normalized_column = requested_column.split(".").last

      return normalized_column if normalized_sort_columns.include?(normalized_column)

      default_filter_sort_column
    end

    def filter_sort_direction
      direction = filter_params[:sort_direction].to_s.downcase
      return direction if %w[ asc desc ].include?(direction)

      default_filter_sort_direction
    end

    def default_filter_sort_column
      return "created_at" if normalized_sort_columns.include?("created_at")

      normalized_sort_columns.first || @model.primary_key.to_s
    end

    def default_filter_sort_direction
      "desc"
    end

    def default_param_required
      @model.to_s.underscore.sub("/", "_").to_sym
    end

    def default_params_permited
      []
    end

    def instance_params
      # Resulte exemple: dog: [ :name, :age, :deleted_at ]
      params.require(default_param_required).permit(default_params_permited)
    end
end
