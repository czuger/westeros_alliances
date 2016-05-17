module Assert

  private

  def assert( class_name, method_name, test, message )
    raise "#{class_name}##{method_name} : #{message}" unless test
  end

  def refute( class_name, method_name, test, message )
    raise "#{class_name}##{method_name} : #{message}" if test
  end

end