class Importer
  attr_accessor :last_row

  def handle_row row
    last_row = row
  end

  def current_set
    @current_set || new_set
  end

  def new_set
    @current_set = WordSet.new
  end

  def begin_new_set
    new_set
  end

  def done
    begin_new_set
  end

end

namespace :db do
  desc "import csv of homophones from lib/assets/homophone_list.csv"

  task :import do
    puts "importing homphones from lib/assets/homophone_list.csv"

    csv_file  = open("#{Rails.root}/lib/assets/homophone_list.csv",'r')
    
    csv_options = { 
      chunk_size:                 100,
      col_sep:                    ",",
      # row_sep: "\r",
      # file_encoding: 'windows-1251:utf-8',

      # key_mapping:  key_mapping,
      verbose:                    true,
      convert_values_to_numeric:  false,
      remove_empty_values:        false,
      remove_zero_values:         false,
      remove_empty_hashes:        false
    }

    importer = Importer.new

    # iterate over CSV rows
    SmarterCSV.process(csv_file, csv_options) do |chunk|
      chunk.each do |row|
        importer.handle_row(row)
      end
    end

    importer.done

    puts "done."

  end

end

