require "gmaps_scrapping/model/greeting"

class GmapsScrapping
    module Controller
        class Scrapping
            # Require gemfile
            require "selenium-webdriver"
            require "write_xlsx"
            require "rubygems"
            require 'json'
           # include Glimmer::LibUI::Application
            $formatted_time = 0;
            def initialize
                @greeting = Model::Greeting.new
            end

            def process_scrapping(keyword, limit)
                current_time = Time.now
                $formatted_time = current_time.strftime('%d/%m/%Y %H_%M')
                # instance driver selenium
                driver = Selenium::WebDriver.for :chrome

                # buka halaman web, url berasal dari keyword yang dimasukan
                driver.get "https://www.google.com/maps/search/#{keyword.gsub(/\s+/, "+")}" # ganti spasi dengan tanda +

                # beri waktu tunggu hingga browser terbuka
                sleep 4 # 4 detik

                # START SCRAPPING PROCESS
                # =======================
                
                # Mengambil elemen dengan kelas 'hfpxzc', nama lokasi
                elements_with_hfpxzc = driver.find_elements(xpath: '//*[contains(@class, "hfpxzc")]')
                # Mengambil elemen dengan kelas 'ZkP5Je', rating dan jumlah ulasan
                elements_with_ZkP5Je = driver.find_elements(xpath: '//*[contains(@class, "ZkP5Je")]')
                # Mengambil elemen dengan kelas MW4etd, jumlah rating
                elements_with_MW4etd = driver.find_elements(css: ".MW4etd")
                # Mengambil elemen dengan kelas UY7F9, Jumlah ulasan
                elements_with_UY7F9 = driver.find_elements(css: ".UY7F9")
                # Mengambil elemen dengan kelas rlmNhf, Harga mulai dari (jika ada)
                elements_with_rlmNhf = driver.find_elements(css: ".rlmNhf")

                # Ambil dan tampilkan aria-label setelah scroll selesai
                aria_labels = []
                arial_labels_rating_dan_ulasan = []
                ratings = []
                jumlah_ulasan = []
                harga_items = []
                alamat_items = []
                email_items = []
                no_telpon_items = []
                link_items = []
                previous_length = 0
                results = []

                # Melakukan scroll sampai 1000 elemen ditemukan

                while elements_with_hfpxzc.length < limit.to_i
                    # Tampilkan jumlah elemen yang ditemukan
                    puts "Jumlah elemen yang ditemukan: #{elements_with_hfpxzc.length}"

                    # Ambil elemen terakhir
                    last_element = elements_with_hfpxzc.last

                    # Scroll ke elemen terakhir
                    driver.execute_script("arguments[0].scrollIntoView(true);", last_element)

                    # Tunggu beberapa detik untuk memastikan scroll terlihat dan elemen dimuat
                    sleep(2) # 2 detik

                    # Ambil elemen lagi setelah scroll untuk mengecek apakah ada elemen baru yang dimuat
                    elements_with_hfpxzc = driver.find_elements(xpath: '//*[contains(@class, "hfpxzc")]') # AMBIL NAMA TEMPAT
                    elements_with_ZkP5Je = driver.find_elements(xpath: '//*[contains(@class, "ZkP5Je")]') # AMBIL JUM RATING DAN ULASAN
                    elements_with_MW4etd = driver.find_elements(css: ".MW4etd") # AMBIL JUMLAH RATING
                    elements_with_MW4etd = driver.find_elements(css: ".UY7F9") # AMBIL JUMLAH ULASAN
                    elements_with_rlmNhf = driver.find_elements(css: ".rlmNhf") # AMBIL HARGA (MULAI DARI), JIKA ADA

                    if elements_with_hfpxzc.length == previous_length
                        puts "Jumlah elemen tidak bertambah, keluar dari loop."
                        break
                      end
                    
                    # Update previous_length dengan panjang terbaru
                    previous_length = elements_with_hfpxzc.length
                end  # END LOOP
                

                # Menampilkan hasil jumlah elemen yang ditemukan
                puts "Total elemen yang ditemukan: #{elements_with_hfpxzc.length}"
                elements_with_hfpxzc.each do |element|
                    aria_label = element.attribute("aria-label")
                    aria_labels << aria_label if aria_label

                    link = element.attribute("href")
                    link_items << link
                end # END LOOP

                link_items.each do |link|
                    begin
                      puts "Navigating to: #{link}"
                  
                      # Kunjungi link
                      driver.get(link)
                      sleep(4) # Tunggu halaman selesai dimuat (opsional, lebih baik pakai WebDriverWait)
                  
                      # Tunggu elemen yang diinginkan muncul
                      wait = Selenium::WebDriver::Wait.new(timeout: 10)
                      address_text = nil
                      phone_number = nil
                  
                      # Cari elemen alamat berdasarkan data-item-id="address"
                      begin
                        address_button = wait.until do
                          driver.find_element(css: 'button[data-item-id="address"]')
                        end
                  
                        # Ambil alamat dari aria-label
                        address_text = address_button.attribute("aria-label")
                        # Menghapus kata "Alamat: " dari teks untuk mendapatkan alamat saja
                        address_text = address_text.sub("Alamat: ", "").strip
                      rescue Selenium::WebDriver::Error::TimeoutError
                        puts "Alamat tidak ditemukan di halaman ini"
                      end
                  
                      # Cari elemen nomor telepon berdasarkan data-item-id yang mengandung "phone"
                      begin
                        phone_button = driver.find_element(css: 'button[data-item-id*="phone"]')
                  
                        # Ambil nomor telepon dari aria-label
                        phone_number = phone_button.attribute("aria-label")
                        # Menghapus kata "Telepon: " dari teks untuk mendapatkan nomor telepon saja
                        phone_number = phone_number.sub("Telepon: ", "").strip
                      rescue Selenium::WebDriver::Error::TimeoutError
                        puts "Nomor telepon tidak ditemukan di halaman ini"
                      end
                  
                      # Simpan alamat dan nomor telepon
                      alamat_items << (address_text || "Alamat tidak tersedia")
                      no_telpon_items << (phone_number || "No. Telp tidak tersedia")
                    rescue StandardError => e
                      puts "Error navigating to #{link}: #{e.message}"
                    end
                  
                    # Kembali ke halaman utama
                    driver.navigate.back
                    sleep(2) # Tunggu halaman utama selesai dimuat (opsional)
                  end # END LOOP

                  elements_with_ZkP5Je.each do |element_jum_rating_ulasan|
                    aria_label = element_jum_rating_ulasan.attribute("aria-label")
                    arial_labels_rating_dan_ulasan << aria_label if aria_label
                  end
                  
                  elements_with_class = driver.find_elements(css: ".MW4etd")
                  elements_with_class.each do |element|
                    ratings << element.text if element.displayed? # Ambil teks yang terlihat
                  end
                  
                  elements_with_class = driver.find_elements(css: ".UY7F9")
                  elements_with_class.each do |element|
                    jumlah_ulasan << element.text.gsub(/[()]/, "") if element.displayed? # Hapus tanda kurung dari teks
                  end

                elements_with_rlmNhf = driver.find_elements(css: ".rlmNhf")
                    elements_with_rlmNhf.each do |element|
                    # Cek elemen anak dengan class "fontHeadlineSmall"
                    begin
                        harga_element = element.find_element(css: ".fontHeadlineSmall")
                        value = harga_element.text.strip # Ambil teks dan hapus spasi kosong
                        harga_items << value if value != "" # Simpan hanya jika teks tidak kosong
                    rescue Selenium::WebDriver::Error::NoSuchElementError
                        # Jika tidak ada elemen dengan class "fontHeadlineSmall", lanjutkan
                        next
                    end
                end

                aria_labels.each_with_index do |label, index|
                    rating = ratings[index] || "Rating tidak tersedia"
                    ulasan = jumlah_ulasan[index] || "Jumlah ulasan tidak tersedia"
                    harga = harga_items[index] || "Harga tidak tersedia"
                    alamat = alamat_items[index] || "Alamat tidak tersedia"
                    email = email_items[index] || "Email tidak tersedia"
                    no_telpon = no_telpon_items[index] || "No. Telp tidak tersedia"
                    link = link_items[index] || "Link tidak tersedia"

                    results << {
                        nama_lokasi: label,
                        rating: rating,
                        jumlah_ulasan: ulasan,
                        harga: harga,
                        alamat: alamat,
                        email: email,
                        no_telpon: no_telpon,
                        link: link
                    }

                  end
                  
                  results_to_json(results, keyword)
                 

                  # Menutup browser setelah selesai
                  driver.quit
               
                # =====================
                # END SCRAPPING PROCESS
            end 
            
            def results_to_json(results, keyword)
                title_file_json = "result_#{keyword.gsub(/\s+/, "+")}.json";
                File.open(title_file_json, 'w') do |file|
                  file.write(JSON.pretty_generate(results))
                end
                result_to_history(keyword, $formatted_time, title_file_json)
            end

            def result_to_history(keyword, date, file_name)
              file_path = "riwayat_pencarian.json"
              
              # Jika file sudah ada, baca konten sebelumnya
              if File.exist?(file_path)
                begin
                  # Baca file dan parse JSON
                  file = File.read(file_path)
                  data = JSON.parse(file, symbolize_names: true)
            
                  # Tambahkan entri baru ke data
                  new_entry = { keyword: keyword, date: date, file_name: file_name }
                  data << new_entry
            
                  # Tulis kembali data ke file
                  File.open(file_path, 'w') do |f|
                    f.write(JSON.pretty_generate(data))
                  end
                rescue JSON::ParserError => e
                  puts "Error parsing JSON: #{e.message}"
                end
              else
                # Jika file belum ada, buat file baru dan tambahkan data
                new_entry = [{ keyword: keyword, date: date, file_name: file_name }]
                File.open(file_path, 'w') do |f|
                  f.write(JSON.pretty_generate(new_entry))
                end
              end
            end
            

        end
    end
end
