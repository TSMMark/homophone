
get started buttons on every homepage panel

word-popup can click to view further definition info, etc

top-right corner of card has button to inspect word_set


newly added homophones
popular homophones
browse by letter
random homophone



rails g scaffold homophone_set visits:integer

rails g scaffold words text visits:integer

add spelling option to word



cache

rails g scaffold definitions word_id:integer text part_of_speech source_dictionary attribution_text

rails g scaffold pronounciations word_id:integer file_url attribution_text
