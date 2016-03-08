# encoding: UTF-8

require 'test/unit'
require 'test/unit/ui/console/testrunner'

require 'shoes/videoffi'
Vlc.load_lib

require 'video_vlc_01.rb'
    
Shoes.app title: "Testing Shoes video" do
    VideoVlcTestBase.init self
    TESTS = {
        VideoVlcTest1 => ["Testing initialisation of video widget without a given path to a media\n",
                        span("Run this first to ensure that video widget works at its bare minimum\n", 
                            stroke: darkred),
                        "Testing procedure to wait for Drawing Area to be ready for vlc to use it"],
        VideoVlcTest2 => "Testing initialisation of video widget with a given path to a movie\n" \
                        "relying on video track size if no widget or parent canvas dimensions provided", 
        VideoVlcTest3 => "Testing audio facility", 
        VideoVlcTest4 => "Testing media loading",
        VideoVlcTest5 => "Passing vlc options to underlaying libvlc_new() C method"
    }
    # we must wait for shoes asynchronous drawing events to occur
    @run_test = -> (suite) { Thread.new {Test::Unit::UI::Console::TestRunner.run(suite)}; puts '='*40 }
    
    style(Shoes::Para, size: 10)
    stack do
        para "\t\tLaunches Shoes terminal to collect results of Tests"
        
        flow margin: [0,0,0,10] do 
            button "run ALL Tests" do
                # There could be only one console at a time (we can safely call it many times)
                Shoes.show_console
                Thread.new {
                    tests = Test::Unit::TestSuite.new("All Tests")
                    TESTS.each { |t,d| tests << t.suite }
                    @run_test.call(tests)
                }
            end
            para "  in order of appearance, top to bottom"
        end
        
        TESTS.each do |t, desc|
            flow do 
                button "run Test" do
                    Shoes.show_console
                    @run_test.call(t.suite)
                end
                
                para *(["#{t.to_s} : \n"] << desc)
            end        
        end
        
    end
    
end