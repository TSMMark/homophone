class Importer
  attr_accessor :last_row

  def handle_row row
    # relation_id,word_id,text,spelling

    row.symbolize_keys!
    
    word_attibutes = {}

    if row[:spelling] && row[:spelling] != "NULL"
      word_attibutes[:text] = row[:spelling]
      word_attibutes[:display_text] = row[:text]
    else
      word_attibutes[:text] = row[:text]
    end

    word = Word.find_or_create_by(word_attibutes)

    if last_row && last_row[:relation_id] == row[:relation_id]
      current_set.append_word(word)
    else
      new_set.append_word(word)
    end

    self.last_row = row
  end

  def current_set
    @current_set || new_set
  end

  def new_set
    done
    @current_set = WordSet.new
  end

  def done
    @current_set && @current_set.save!
  end

end

namespace :db do
  desc "import csv of homophones from lib/assets/homophone_list.csv"

  task :import => :environment do
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

