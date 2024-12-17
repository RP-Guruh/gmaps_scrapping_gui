# Delete this example model and replace with your own model
class GmapsScrapping
  module Model
    class Greeting
      Maps = Struct.new(:name, :address, :price, :rate_stars, :total_ulasan, :phone, :website, :link_maps)

      GREETINGS = [
        "Hello, GUruh",
        "Howdy, Partner!",
      ]

      attr_accessor :text
      attr_accessor :keyword, :limit_scrolling, :maps, :name, :address, :price, :rate_stars, :total_ulasan, :phone, :website, :link_maps

      def initialize
        @text = GREETINGS.first
        @keyword = "hotel di kota depok"
        @limit_scrolling = "100"
        @maps = [];
        # @maps = [
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        #   Maps.new("Hotel Bidakara", "Jl. Lap. Banteng Selatan No.1, Ps. Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710", "720-523-4329", "borobudur.com", "https://www.rubydoc.info/search/gems/glimmer/0.9.2?q=label"),
        # ]
      end

      def text_index=(new_text_index)
        self.text = GREETINGS[new_text_index]
      end

      def text_index
        GREETINGS.index(text)
      end
    end
  end
end
