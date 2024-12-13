require "gmaps_scrapping/model/greeting"

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
        menu_bar
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
                msg_box("searching di klik")
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

      def table_layout
        table {
          text_column("Name")
          text_column("Address")
          text_column("Phone")
          text_column("Website")
          text_column("Link Maps")

          cell_rows <=> [@greeting, :maps]
          on_changed do |row, type, row_data|
            puts "Row #{row} #{type}: #{row_data}"
            $stdout.flush # for Windows
          end
        }
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