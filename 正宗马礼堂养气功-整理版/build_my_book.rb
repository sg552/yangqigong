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
copy_xml("new/1.前言与概论.xml", "1.xml")
copy_xml("new/2.六字诀.xml", "2.xml")
copy_xml("new/3.洗髓金经.xml", "3.xml")
copy_xml("new/4.站坐卧功.xml", "4.xml")
copy_xml("new/5.问答.xml", "5.xml")
copy_xml("new/6.痊愈病例.xml", "6.xml")
copy_xml("new/附 VCD六字诀中马老原音.xml", "appendix1.xml")
copy_xml("new/附 VCD洗髓金经马老原音.xml", "appendix2.xml")
copy_xml("new/附 六字诀出场人物.xml", "appendix_people.xml")
copy_xml("new/附 马礼堂的相关事迹.xml", "appendix_story.xml")
copy_xml("new/附 来自网络的痊愈病例.xml", "appendix_cured_cases.xml")
copy_xml("new/附 交流与讨论.xml", "appendix_discussion.xml")

start_time =  Time.new
#system('bd_html malitang zh-cn')
#system('bd_chunk malitang zh-cn')
system('bd_fo malitang zh-cn')
system('bdj_pdf malitang zh-cn')
puts start_time
puts Time.new
