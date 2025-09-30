module PathHelper
  def instances_index_path
    path = "#{build_namespace}_#{model_plural_name}_path"
    send(path)
  end

  def instance_show_path(instance)
    path = "#{build_namespace}_#{model_singular_name}_path"
    send(path, instance)
  end

  def instance_new_path
    path = "new_#{build_namespace}_#{model_singular_name}_path"
    send(path)
  end

  def instance_create_path
    path = "#{build_namespace}_#{model_plural_name}_path"
    send(path)
  end

  def instance_edit_path(instance)
    path = "edit_#{build_namespace}_#{model_singular_name}_path"
    send(path, instance)
  end

  def instance_remove_path(instance)
    path = "#{build_namespace}_#{model_singular_name}_path"
    send(path, instance)
  end

  def instance_update_path(instance)
    path = "#{build_namespace}_#{model_singular_name}_path"
    send(path, instance)
  end
end
