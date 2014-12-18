require "rake"

# https://gist.github.com/equivalent/5107645 
shared_context "rake" do
  let(:rake) { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) do
    full_path_name = task_name.split(":")
    full_path_name.pop
    task_parent_dir = full_path_name.join("/")
    "lib/tasks/#{task_parent_dir}"
  end
  subject { rake[task_name] }
 
  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end
 
  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)
 
    Rake::Task.define_task(:environment)
  end
end
