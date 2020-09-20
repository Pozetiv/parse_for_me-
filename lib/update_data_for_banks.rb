class UpdateDataForBanks
  require 'nokogiri'
  require 'open-uri'

  def update_for_rncb
    page = set_page('https://www.rncb.ru/fizicheskkim-litsam/valyutnye-operatsii/')

    rows = page.css('table.cours tr:nth-child(2), table.cours tr:nth-child(3)')

    arr = array_datum(rows)
    hash_with_data = create_hashes(arr)

    return if deferent?(Bank.find_by(name: "rncb").report_datum.last, hash_with_data)

    Bank.find_by(name: "rncb").report_datum.create(hash_with_data)
  end

  def update_for_morskoybank
    page = set_page('http://morskoybank.com/')

    rows = page.css('table.little tr:nth-child(2), table.little tr:nth-child(3)')

    arr = array_datum(rows)
    hash_with_data = create_hashes(arr)

    return if deferent?(Bank.find_by(name: "morskoybank").report_datum.last, hash_with_data)

    Bank.find_by(name: "morskoybank").report_datum.create(hash_with_data)
  end

  def update_for_cbrr
    page = Nokogiri::HTML(URI.open('https://www.chbrr.crimea.com/'), nil, 'UTF-8')

    rows = page.css('table')[0].css('tr:nth-child(1),  tr:nth-child(2)')

    arr = array_datum(rows)
    hash_with_data = create_hashes(arr)

    return if deferent?(Bank.find_by(name: "cbrr").report_datum.last, hash_with_data)

    Bank.find_by(name: "cbrr").report_datum.create(hash_with_data)
  end

  def update_for_genbank
    page = set_page('https://www.genbank.ru/')

    rows = page.css('.footer_kurs table tr:nth-child(2), .footer_kurs table tr:nth-child(3)')

    arr = array_datum(rows)
    hash_with_data = create_hashes(arr)

    return if deferent?(Bank.find_by(name: "genbank").report_datum.last, hash_with_data)

    Bank.find_by(name: 'genbank').report_datum.create(hash_with_data)
  end

  private

  def set_page(url)
    Nokogiri::HTML(URI.open(url), nil, 'UTF-8')
  end

  def array_datum(arrays)
    result = arrays.map do |row|
              row.css('td').map(&:text)
             end

    destroy_russian_letter(result)
  end

  def destroy_russian_letter(arrays)
    arrays.map do |array|
      array.delete_if {|x| x =~ /[А-Яа-я]/ || x.empty? }
    end
  end

  def create_hashes(array)
    hash = {}

    array.each do |arrs|
      next if arrs.empty?

      name_hash = if arrs.include?('USD') || arrs.include?('EUR')
                    arrs[0].downcase
                  else
                    'gold'
                  end

      hash[name_hash] = { 'buying' => stipe_data(arrs[1]), 'selling' => stipe_data(arrs[2]) }
    end

    hash
  end

  def stipe_data(data)
    return data.strip unless data.index(/[+|-]/)

    add_info = data[data.index(/[+|-]/)..-1]
    data.remove(add_info).strip!
  end

  def deferent?(last_data, actual_data)
    last_data_only_cources = last_data.attributes.except!('created_at', 'updated_at',
                                                          'bank_id', 'gold', 'id')

    last_data_only_cources == actual_data
  end
end