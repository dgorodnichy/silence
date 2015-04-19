require 'cucumber/formatter/html.rb'

# Very simple report with execution status for each scenario without steps description.
class SilenceHtml < Cucumber::Formatter::Html

  def tag_name(tag_name)
    @tags = [] if @tags.nil?
    @tags << tag_name
  end

  def scenario_name(keyword, name, file_colon_line, source_indent)
    @builder.span(:class => 'scenario_file') do
      @builder << file_colon_line
    end
    @listing_background = false
    unless @tags.nil?
      if @tags.include? "@known_bug"
        @known_bug_h3 = "known_bug_title"
      else
        @known_bug_h3 = "normal_title"
      end
    end
    @builder.h3(:id => "scenario_#{@scenario_number}", :class => @known_bug_h3) do
      @builder.span(keyword + ':', :class => 'keyword')
      @builder.text!(' ')
      @builder.span(name, :class => 'val')
      @builder.text!(' ')
      @builder.span("")
      tags_in_title(@tags)
    end
    @tags = nil
  end

  def build_exception_detail(exception)
    backtrace = Array.new
    @builder.div(:class => 'message') do
      message = exception.message

      unless exception.instance_of?(RuntimeError)
        message = "#{message} (#{exception.class})"
      end

      @builder.pre do
        @builder.text!(message)
      end
    end
    @builder.div(:class => 'backtrace') do
      @builder.a("backtrace", :class => 'backtrace_toggle')
      @builder.pre(:class => 'backtrace_details', style: "display:none") do
        exception.backtrace.each { |trace|  
          if trace.include? Dir.getwd
            @builder.span(style: "font-weight:bold;") do
              @builder << "#{trace}\n"
            end
          else
            @builder.span(style: "color: #303030;") do
              @builder << "#{trace}\n"
            end
          end
        }
      end
    end
    extra = extra_failure_content(exception.backtrace)
    @builder.div do 
      @builder.a("ruby code", :class => 'ruby_error_toggle')
      @builder.div(:class => "ruby_error", :style => "display:none;") do 
        @builder << extra unless extra == ""
      end
    end
  end

  def tags_in_title(tags)
    unless tags.nil?
      tags.each do |tag| 
        @builder.span(tag, :class => 'tag_in_title') 
      end
    end
  end

  def before_steps(steps)
    @builder << '<ol style="display:none;">'
  end

  def inline_css
    super
    @builder.style(:type => 'text/css') do
      @builder << File.read(File.dirname(__FILE__) + '/inline_css.css')
    end
  end

  # Adds custom inline JavaScript code
  def inline_js_content
    File.read(File.dirname(__FILE__) + '/inline_js.js')
  end

  def inline_js_content
    <<-EOF
  SCENARIOS = "h3[id^='scenario_'],h3[id^=background_]";
  $(document).ready(function() {
    $(SCENARIOS).css('cursor', 'pointer');
    $(SCENARIOS).click(function() {
      $(this).siblings().toggle(250);
    });
    $("#collapser").css('cursor', 'pointer');
    $("#collapser").click(function() {
      $(SCENARIOS).siblings().hide();
    });
    $("#expander").css('cursor', 'pointer');
    $("#expander").click(function() {
      $(SCENARIOS).siblings().show();
    });
  })
  $(document).ready(function() {
    $(".backtrace_toggle").css('cursor', 'pointer');
    $(".backtrace_toggle").click(function() {
      $(this).siblings().toggle(250);
    });
    $("#collapser").css('cursor', 'pointer');
    $("#collapser").click(function() {
      $(".backtrace_toggle").siblings().hide();
    });
    $("#expander").css('cursor', 'pointer');
    $("#expander").click(function() {
      $(".backtrace_toggle").siblings().show();
    });
  })
  $(document).ready(function() {
    $(".ruby_error_toggle").css('cursor', 'pointer');
    $(".ruby_error_toggle").click(function() {
      $(this).siblings().toggle(250);
    });
    $("#collapser").css('cursor', 'pointer');
    $("#collapser").click(function() {
      $(".ruby_error_toggle").siblings().hide();
    });
    $("#expander").css('cursor', 'pointer');
    $("#expander").click(function() {
      $(".ruby_error_toggle").siblings().show();
    });
  })
  function moveProgressBar(percentDone) {
    $("cucumber-header").css('width', percentDone +"%");
  }
  function makeRed(element_id) {
    $('#'+element_id).css('background', '#660000');
    $('#'+element_id).css('color', '#FFFFFF');
  }
  function makeYellow(element_id) {
    $('#'+element_id).css('background', '#FAF834');
    $('#'+element_id).css('color', '#000000');
  }
    EOF
  end

end
