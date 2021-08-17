require 'fileutils'

include FileUtils

SRC_DIR="D:/workspace/doc/"
DIST_DIR="D:/obp/books/malitang/zh-cn/src/"
FIGURE_DIR=SRC_DIR+"new/figure/"

def copy_xml(src_file, dist_file=src_file)
  cp(SRC_DIR+src_file, DIST_DIR+File.basename(dist_file))
end

def copy_images
   cp_r Dir.glob(FIGURE_DIR+"*.jpg"), DIST_DIR+"figure/"
end


copy_images
copy_xml("malitang.xml")
copy_xml("new/1.ǰ�������.xml", "1.xml")
copy_xml("new/2.���־�.xml", "2.xml")
copy_xml("new/3.ϴ���.xml", "3.xml")
copy_xml("new/4.վ���Թ�.xml", "4.xml")
copy_xml("new/5.�ʴ�.xml", "5.xml")
copy_xml("new/6.Ȭ������.xml", "6.xml")
copy_xml("new/�� VCD���־�������ԭ��.xml", "appendix1.xml")
copy_xml("new/�� VCDϴ�������ԭ��.xml", "appendix2.xml")
copy_xml("new/�� ���־���������.xml", "appendix_people.xml")
copy_xml("new/�� �����õ�����¼�.xml", "appendix_story.xml")
copy_xml("new/�� ���������Ȭ������.xml", "appendix_cured_cases.xml")
copy_xml("new/�� ����������.xml", "appendix_discussion.xml")

start_time =  Time.new
#system('bd_html malitang zh-cn')
#system('bd_chunk malitang zh-cn')
system('bd_fo malitang zh-cn')
system('bdj_pdf malitang zh-cn')
puts start_time
puts Time.new
