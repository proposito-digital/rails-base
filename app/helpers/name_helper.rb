module NameHelper
  def plural_model_name
    params[:controller].split("/")[-1]
  end

  def singular_model_name
    singularize(plural_model_name)
  end

  def build_namespace
    params[:controller].gsub(plural_model_name, "").gsub("/", "_").delete_suffix("_")
  end

  def model_singular_name
    @model.to_s.underscore
  end

  def model_singular_name_to_translate(instance)
    instance.class.name.to_s.underscore.gsub("::", "/")
  end

  def model_plural_name
    model_singular_name.pluralize
  end

  def model_plural_name_to_sort
    model_singular_name.pluralize.gsub("/", "_")
  end

  def model_field_id(instance, attribute)
    "#{instance.class.name.to_s.underscore.gsub("/", "_")}_#{attribute}"
  end

  def model_singular_translation
    t("#{model_plural_name}.single")
  end

  def custom_model_singular_translation(model)
    t("#{model}.single")
  end

  def model_plural_translation
    t("#{model_plural_name}.plural")
  end

  def custom_model_plural_translation(model)
    t("#{model.pluralize.downcase.gsub("::", "/")}.plural")
  end

  def model_column_names
    @model.column_names.to_a
  end

  def model_column_names_only(attributes_names)
    @model.column_names.select { |column_name| attributes_names.include? column_name }
  end
end
