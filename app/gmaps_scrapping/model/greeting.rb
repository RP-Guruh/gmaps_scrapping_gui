# Delete this example model and replace with your own model
class GmapsScrapping
  module Model
    class Greeting
      Maps = Struct.new(:name, :address, :price, :rate_stars, :total_ulasan, :phone, :website, :link_maps)
      Histories = Struct.new(:scrapping_date, :json_file)
     
      GREETINGS = [
        "Hello, GUruh",
        "Howdy, Partner!",
      ]

      attr_accessor :histories
      attr_accessor :text
      attr_accessor :keyword, :limit_scrolling, :maps, :name, :address, :price, :rate_stars, :total_ulasan, :phone, :website, :link_maps
      attr_accessor :scrapping_date, :json_file
      def initialize
        @text = GREETINGS.first
        @keyword = "hotel di kota depok"
        @limit_scrolling = "100"
        @maps = [];
        get_history


        #@histories = Histories.new('123 Main St', '23923')
        
      end

      def text_index=(new_text_index)
        self.text = GREETINGS[new_text_index]
      end

      def get_history
        directory = "./"
        file_content = Dir.glob("#{directory}**/riwayat_pencarian.json").first
        
        # Check if the file exists
        if file_content
          file_data = File.read(file_content)
          data = JSON.parse(file_data, symbolize_names: true)
          # Assign the data to @greeting.history
          @histories = data.map do |item|
            {
              keyword: item[:keyword],
              date: item[:date],
              file_name: item[:file_name]
            }
          end
        
          
        else
          @histories = [] # If file is not found, set an empty array
        end
      end

      def text_index
        GREETINGS.index(text)
      end
    end
  end
end
