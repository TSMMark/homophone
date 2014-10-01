module LayoutHelper
  def body_class
    [
      current_path == "/" ? "home" : nil
    ].compact.join(" ")
  end
end
