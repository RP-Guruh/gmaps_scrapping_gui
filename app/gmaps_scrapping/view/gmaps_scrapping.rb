require "gmaps_scrapping/model/greeting"
require "gmaps_scrapping/controller/scrapping"

class GmapsScrapping
  module View
    class GmapsScrapping
      include Glimmer::LibUI::Application

      ## Add options like the following to configure CustomWindow by outside consumers
      #
      # options :title, :background_color
      # option :width, default: 320
      # option :height, default: 240

      ## Use before_body block to pre-initialize variables to use in body and
      #  to setup application menu
      #
      before_body do
        @greeting = Model::Greeting.new
        @controller = Controller::Scrapping.new
        menu_bar
        read_json_result
      end

      ## Use after_body block to setup observers for controls in body
      #
      # after_body do
      #
      # end

      ## Add control content inside custom window body
      ## Top-most control must be a window or another custom window
      #
      body {
        window {

          # Replace example content below with your own custom window content
          content_size 1200, 350
          title "Google Maps Scrapping version 1.0"
          resizable false
          margined true

          vertical_box {
            form {
              entry {
                label "Keyword Pencarian" # label property is available when control is nested under form
                text <=> [@greeting, :keyword] # bidirectional data-binding of entry text property to self first_name attribute
              }

              entry {
                label "Limit Pencarian" # label property is available when control is nested under form
                text <=> [@greeting, :limit_scrolling] # bidirectional data-binding of entry text property to self first_name attribute
              }
            }
            button("Searching") {
              stretchy false
              on_clicked do
                if @greeting.keyword.empty? || @greeting.limit_scrolling.empty? 
                  msg_box_error('Validation Error!', 'All fields are required! Please make sure to enter a value for all fields.')
                else
                  convert_to_integer = @greeting.limit_scrolling.to_i
                  if convert_to_integer > 100
                    msg_box_error('limit maximum error !', 'Limit tidak bisa lebih dari 100')
                  else
                    scrapping_running(@greeting.keyword, @greeting.limit_scrolling) 
                    msg_box('Finish', 'Scrapping telah selesai')
                    read_json_result
                  end
                end              
              end
            }
            button("Download as Excell") {
              stretchy false
              on_clicked do
                msg_box("download file")
              end
            }
            search_box_layout
            table_layout
          }
        }
      }

      def scrapping_running(keyword, limit)
        @controller.process_scrapping(keyword, limit)
      end

      
      def table_layout
        table {
          text_column("Name")
          text_column("Address")
          text_column("Phone")
          text_column("Website")
          text_column("Link Maps")
          cell_rows <=> [@greeting, :maps]
        }
      end

      def read_json_result
           # ISI FILE KE TABEL
           # Direktori tempat file JSON berada
            directory = "./" # Ubah sesuai dengan direktori target

            # Cari semua file .json dalam direktori
            json_files = Dir.glob(File.join(directory, "*.json"))

            # Temukan file yang dimodifikasi paling akhir
            latest_file = json_files.max_by { |file| File.mtime(file) }

            if latest_file
              
              file_content = File.read(latest_file)
              data = JSON.parse(file_content, symbolize_names: true)
  
              @greeting.maps = data.map do |location|
                Model::Greeting::Maps.new(
                  location[:nama_lokasi],
                  location[:alamat],
                  location[:no_telpon],
                  location[:email],
                  location[:link]
                )
              end
            else 
              @greeting.maps = [
                Model::Greeting::Maps.new()
              ]
            end
          
      end

      def search_box_layout
        search_entry {
          stretchy false
        }
      end

    

      def menu_bar
        menu("File") {
          menu_item("Preferences...") {
            on_clicked do
              display_preferences_dialog
            end
          }

          # Enables quitting with CMD+Q on Mac with Mac Quit menu item
          quit_menu_item if OS.mac?
        }
        menu("Help") {
          if OS.mac?
            about_menu_item {
              on_clicked do
                display_about_dialog
              end
            }
          end

          menu_item("About") {
            on_clicked do
              display_about_dialog
            end
          }
        }
      end

      def display_about_dialog
        message = "Gmaps Scrapping #{VERSION}\n\n#{LICENSE}"
        msg_box("About", message)
      end

      def display_preferences_dialog
        window {
          title "Preferences"
          content_size 200, 100

          margined true

          vertical_box {
            padded true

            label("Greeting:") {
              stretchy false
            }

            radio_buttons {
              stretchy false

              items Model::Greeting::GREETINGS
              selected <=> [@greeting, :text_index]
            }
          }
        }.show
      end
    end
  end
end
