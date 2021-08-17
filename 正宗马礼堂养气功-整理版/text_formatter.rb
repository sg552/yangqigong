require 'logger'
require 'iconv'

class TextFormatter

  @@log = Logger.new("D:\\log.txt", 5, 1000*1024)
  @@log.level=Logger::INFO
  XML_SUFFIX=".xml"
  @@text=""
  TOPIC_STRING_LENGTH= 24

  def text
    return @@text    
  end

  def text=(value)
    @@text =value
  end

  def TextFormatter.substitute_qq_number_with_wenhao_in_a_file(file)
    qq_number_regexp=Regexp.new('\d{5,12}')
    File.open(file) do |file|
      while line=file.gets

        if !line.index(qq_number_regexp)
          @@text <<line
        else
          @@text << TextFormatter.substitute_qq_number_with_wenhao(line)
        end
      end
    end
    TextFormatter.write_to_file("result.txt", @@text)  
    
  end

  def TextFormatter.substitute_qq_number_with_wenhao(number_string)
    
    number_string.gsub(Regexp.new('\d{5,12}')) {  |match|
      @@log.debug "#{match}"
      return $`+ match[0, match.length-2]+"??" + $'
    }
  end


  def TextFormatter.add_para_marks_to_a_file(file)
    @@log.debug File.basename(file, ".*")
    TextFormatter.new.read_from_a_file(file)
    write_to_file(file.gsub(".txt",XML_SUFFIX), @@text)
  end
  
  def TextFormatter.add_sect1_title_and_para_marks_to_a_file(file)
    TextFormatter.new.read_from_a_QA_file(file)
    write_to_file(file.gsub(".txt",XML_SUFFIX), Iconv.conv("UTF-8","GBK", @@text))
  end

  # TODO: not convert GBK to UTF encoding...
  def read_from_a_QA_file(file)
    File.open(file) do |file|
      while line= file.gets
        if line != nil
          add_sect1_marks_to_a_line(line)
        end
      end
    end
  end
  
  
  def read_from_a_file(file)
    File.open(file) do |file|
      while line= file.gets
#        line = Iconv.conv('UTF-8',"GBK",line)
#        line << conv.iconv(nil)
        if line != nil
          add_para_marks_to_a_line(line)
        end
      end
    end
  end

  QUESTION_REGEXP = Regexp.new('问：')

  # if some string contains '问：'
  # e.g. : '1．问：什么是气功？'
  def TextFormatter.a_question?(line)
  	return line.index(QUESTION_REGEXP)
  end

  def add_sect1_marks_to_a_line(line)
  	if TextFormatter.a_question?(line)
  	  @@log.info "a question: #{line}"
      line.gsub(QUESTION_REGEXP) { |match|
	  	  @@text << "</sect1><sect1><title>"+"问："+ $' +"</title>"
      }      	  
    else 
      add_para_marks_to_a_line(line)
#      @@log.debug "not a question: #{line}"
    end
#    @@log.debug "text: #{@@text}"    
  end


  # add <para>text</para> to a "text" string 
  def add_para_marks_to_a_line(line)
    if line.length > TOPIC_STRING_LENGTH
      @@text << "<para>"+line+"</para>"
    else 
      @@log.warn "not a para? #{line}"
      @@text <<line
    end
#    @@log.debug "text: #{@@text}"
  end
  
  def TextFormatter.write_to_file(file_name, text)
    file = File.new(file_name, "w")
    file.puts text
    file.close
  end

end