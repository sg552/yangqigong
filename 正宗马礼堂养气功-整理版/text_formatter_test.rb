require 'test/unit'
require 'text_formatter'
require 'logger'
require 'find'

class TextFormatterTest<Test::Unit::TestCase
  @@log = Logger.new("D:\\log.txt", 5, 1000*1024)
#  @@log = Logger.new("book.txt")
  @@log.level=Logger::INFO
  DIR ="book_of_malitang_origin"
  DIR_OF_PRINT= "book_of_malitang_for_print"
  DIR_OF_NEW ="new"
  file=""
  @@text = ""
  
  FILE_1= "1.前言与概论.txt"
  FILE_2= "2.六字诀.txt"
  FILE_3="3.洗髓金经.txt"
  FILE_4="4.站坐卧功.txt"
  FILE_5="5.问答.txt"
  FILE_5_TEMP="5.问答.txt.temp"
  
  FILE_6="6.痊愈病例.txt"
  FILE_7="附 来自网络的痊愈病例.txt"
  FILE_8="附 马礼堂事迹3.txt"

  def test_substitute_qq_number_with_wenhao_in_a_file
    file = "temp.txt"
    TextFormatter.substitute_qq_number_with_wenhao_in_a_file(file)
  end
  
  def test_substitute_qq_number_with_wenhao
    result = TextFormatter.substitute_qq_number_with_wenhao("510045240")
    assert result == "5100452??"
    result = TextFormatter.substitute_qq_number_with_wenhao("123456789012")
    assert result == "1234567890??"
    result = TextFormatter.substitute_qq_number_with_wenhao("12345")
    assert result == "123??"
  end

  def test_regexp
    string = "    1．问：什么是气功？"
  	assert TextFormatter.a_question?(string)
    string2 = "    答：元气又称“原气”、“真气”。它是由精化生、随着生命而来的，"
    assert !TextFormatter.a_question?(string2)
    
  end
  
  def test_add_sect1_marks_to_a_line
    line="    1．问：什么是气功？"
    formatter = TextFormatter.new
    formatter.text=("")   
    formatter.add_sect1_marks_to_a_line(line)
    assert formatter.text=="</sect1><sect1><title>问：什么是气功？</title>"
  end
  
  def test_add_para_marks_to_a_line
    formatter = TextFormatter.new
    formatter.text=("")    
    line="    汤饵针灸不能收效的胃下垂患者，通过练养气功腹式呼。"
    formatter.add_para_marks_to_a_line(line)
    assert formatter.text =="<para>"+line+"</para>"
    line="第一章 六字诀"
    formatter.text=("")
    formatter.add_para_marks_to_a_line(line)
    assert formatter.text == line
    formatter.text=("")    
  end
  
  
  
  # change the FILE_X to process some file.
  def not_test_add_marks_to_a_file
    TextFormatter.add_para_marks_to_a_file(DIR_OF_NEW+File::SEPARATOR+
    	FILE_7) 
  end

  def not_test_add_sect1_marks_to_a_file
    TextFormatter.add_sect1_title_and_para_marks_to_a_file(
    	DIR_OF_NEW+File::SEPARATOR+
    	FILE_5) 
  end
  
  
  # remove all the marks such as :" <!-原书第    1页结束->
  def not_test_remove_all_the_marks_of_original_book
    
    Find.find(DIR_OF_PRINT) do |f|
		remove_all_the_marks_of_one_file("output",f)    
    end
  end

  def not_test_remove_all_the_marks_of_one_file
#  	file= "2.六字诀.txt"
#	file= "1.前言与概论.txt"
	#file="3.洗髓金经.txt"
	#file="4.站坐卧功.txt"
#	file="5.问答.txt"
	file="6.痊愈病例.txt"
  	remove_all_the_marks_of_one_file("output",DIR_OF_PRINT+File::SEPARATOR+file)
  end

  def remove_all_the_marks_of_one_file(output_dir,f)
      @@log.debug "processing file: #{f}..."
      if f.include? "txt"
        substitute_the_marks(f)
        TextFormatter.write_to_file(output_dir+File::SEPARATOR+File.basename(f), @@text)
        @@text=""
      end
  
  end
  
  def test_write_to_file
    TextFormatter.write_to_file("1.test.txt", "hahahaha")
  end
  
  def not_test_substitute_the_marks
    substitute_the_marks(DIR_OF_PRINT+File::SEPARATOR+"1.前言与概论.txt")
    @@log.info @@text
  end
  
  # rename this method name to "test_..." if you want to make it work. 
  def not_test_read_head_part
    files_part1 = ["9-14(15~20略).TXT", "33-39(21~32略).TXT", "40-43.txt", "44-47.txt", "48-55.TXT",
              "56-57概述结束.TXT", "58-59.TXT"]
    files_part2 = Array.new
    #从60开始，到 471
    (60..471).to_a.each{  |i|
      files_part2 << i.to_s+".TXT"
    }
    read_from_files(files_part1 + files_part2)
  end
  
  def read_from_files(files_array)
    files_array.each {|i| 
      begin
        read_from_a_txt_file(i)
      rescue
        @@log.warn "#{i} not exists..."      
      end
    }
    @@log.info "result:"+@@text
  end
  
  # file_name ,e.g: 100.TXT
  def read_from_a_txt_file(file_name)
#    file = DIR+ "/100.TXT"
    file = DIR+ "/"+ file_name 
    File.open(file) do |file|
      while line= file.gets
        if line != nil
          @@log.debug "original: -->|" + line +"|<--end"
          process_line(line)
        end
      end
    end
#    @@log.debug "#{file}'s text:"+@@text
    puts "file #{file_name} processed ." 
  end

    def substitute_the_marks(file_name)
    regexp = Regexp.new("<!-.*->")
    File.open(file_name) do |txt_file| 
      while line=txt_file.gets
        @@log.debug line        
        if !line.index(regexp)
          @@log.debug ""
          @@text << line
        else 
          # replace  <!-原书第    1页结束->  to ""
          line.gsub(regexp) { |match|
            @@log.info "#{match}"
            @@log.debug "#{match}: #{$`}, #{$&}, #{$'}"
            @@text << $` << $'
          }
        end
        
      end
    end
  end

  # FIXED ：未处理 “第X章 第X节”开头的行   
  # 处理文本
  def process_line(line)
    # ? 如果这一行的内容，仅仅有空格，或者换行，那么保留它。
    if !blank_line?(line)    
      # 首先去掉该文本的回车 \n
      line_without_separator = line.chomp
      # 如果这一行是接上一行的描述，他们组成了一个段落，那么加到上一行。
      if content_that_follows_the_previous_line?(line_without_separator)
        @@text << line_without_separator
      # 如果这一行的内容，仅仅是一个数字，那么视它为一个页码。
      elsif page_number?(line_without_separator)
        @@text << "<!-原书第"+line_without_separator+"页结束->"
      # 其他情况 与 （如果这一行是以空格开始的行数，那么视它为一个新的段落的开头。）
      else 
        @@text << "\n" + line_without_separator
      end
    # 对空白行，什么也不做。
    end
  end

  
  def test_page_number?
    assert page_number?("   333")
    assert page_number?("333   ")
    assert !page_number?(" aaa")
    assert !page_number?("")
  end
  
  def page_number?(line)
    begin
      return Integer(line.strip)
    rescue
      return false
    end
  end

  # this is needed
  def test_content_that_follows_the_previous_line?
    assert !content_that_follows_the_previous_line?("  汉字某段开头")
    assert !content_that_follows_the_previous_line?("  63")
    assert !content_that_follows_the_previous_line?("   ")
    assert content_that_follows_the_previous_line?("继续上一句话………………")
  end
  
  def content_that_follows_the_previous_line?(content)
    return !page_number?(content) && content.index(" ")!=0 && (!blank_line?(content))
  end

  def test_blank_line
    assert !blank_line?("lala")
    assert blank_line?("")
    assert !blank_line?("    lala")
    assert blank_line?("   ")
    assert blank_line?("\n")
  end

  
  def blank_line? (content)
    return content.strip.size == 0
  end
  
end