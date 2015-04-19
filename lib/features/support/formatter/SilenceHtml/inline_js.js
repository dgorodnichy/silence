(function($){
    $(document).ready(function() {
        SagreHtmlReport.init()
        $(SagreHtmlReport.SCENARIO_HEADER_LOCATOR).css('cursor', 'pointer');

        $(SagreHtmlReport.SCENARIO_HEADER_LOCATOR).click(function() {
            SagreHtmlReport.toggleScenarioDetails(this.parentNode)
        });

        $("#show-only-failed-scenarios-action").click(function() {
            SagreHtmlReport.showOnlyFailedScenarios()
        });

        $(".steps-action").click(function() {
            SagreHtmlReport.toggleScenarioSteps(this)
        });

        $("#show-only-passed-scenarios-action").click(function() {
            SagreHtmlReport.showOnlyPassedScenarios()
            SagreHtmlReport.setShowMode(SagreHtmlReport.SHOW_ONLY_PASSED)
        });

        $("#show-all-scenarios-action").click(function() {
            SagreHtmlReport.showAllScenarios();
            SagreHtmlReport.setShowMode(SagreHtmlReport.SHOW_ALL)
        });

        $("#expand-all-scenarios-action").click(function() {
            SagreHtmlReport.expandAll()
        });
        $("#collapse-all-scenarios-action").click(function() {
            SagreHtmlReport.collapseAll()
        });
        $("#expand-only-failed-scenarios-action").click(function() {
            SagreHtmlReport.expandOnlyFailedScenarios()
        });
        $("#expand-only-pending-scenarios-action").click(function() {
            SagreHtmlReport.expandOnlyPendingScenarios()
        });
        $("#expand-only-successful-scenarios-action").click(function() {
            SagreHtmlReport.expandOnlySuccessfulScenarios();
        });

        $("#toggle-backtrace-action").click(function() {
            return SagreHtmlReport.toggleAllBacktrace()
        });

        $(".backtrace-action").click(function() {
            return SagreHtmlReport.toggleBacktrace(this)
        });

        $("#toggle-ruby-code-action").click(function() {
            SagreHtmlReport.toggleAllRubyCode();
        });

        $(".ruby-action").click(function() {
            SagreHtmlReport.toggleRubyCode(this)
        });

        $(SagreHtmlReport.onlyKnownFailsSelector).click(function() {
            SagreHtmlReport.toggleKnownFails()
        });

        $(SagreHtmlReport.unknownFailsSelector).click(function() {
            SagreHtmlReport.toggleUnknownFails()
        });

        SagreHtmlReport.collapseAll();
        if (SagreHtmlReport.urlAnchor()) {
            SagreHtmlReport.toggleScenarioDetails(jQuery(SagreHtmlReport.urlAnchor()).children('h3'))
        }
    })
})(jQuery);

function moveProgressBar(percentDone) {
    // Current default functionality does not work correctly. Final width of header is is more than 100%
    //SagreHtmlReport.moveProgressBar(percentDone)
}

SagreHtmlReport = {

    // This method sets default values. It is like a constructor
    init: function() {
        this._showMode = this.SHOW_ALL;
    },

    SHOW_ALL: 'SHOW_ALL',
    SHOW_ONLY_FAILED: 'SHOW_ONLY_FAILED',
    SHOW_ONLY_PASSED: 'SHOW_ONLY_PASSED',

    STATUS_TYPES: 'pending skipped failed',

    rubyCodeSelector: 'div.scenario::visible  pre.ruby, div.background::visible  pre.ruby',

    SCENARIOS_LOCATOR: "h3[id^='scenario_'],h3[id^=background_]",

    SCENARIO_HEADER_LOCATOR: '.scenario_header, .background_header',

    SCENARIO_DETAILS_LOCATOR: '.steps,.examples,.steps-action-container',

    urlAnchor: function() {
        return window.location.hash
    },
    goToBuild: function(buildUrl, pattern) {
        if(buildUrl.search(pattern)) {
            targetUrl=buildUrl;
        } else {
            // Removes '../' from buildUrl if report was opened in Jenkins from main page of a job.
            targetUrl=buildUrl.substr(3);
        }
        window.location.href = targetUrl;
    },

    addTag: function(element_id, bug_id) {
        var newTag = jQuery('<span>', {
            class: 'tag known_bug'
        });

        var newTagLink = jQuery('<a>', {
            class: 'tag',
            target: '_blank',
            href: 'http://prj.adyax.com/issues/' + bug_id,
            text: '@known_bug_#' + bug_id
        });

        jQuery(newTag).prepend(newTagLink)
        jQuery('#'+element_id).prepend(newTag)
    },

    makeRed: function(element_id) {
        jQuery('#'+element_id).removeClass(this.STATUS_TYPES).addClass('failed');
    },
    makeBlue: function(element_id) {
        jQuery('#'+element_id+':not(.failed)').removeClass(this.STATUS_TYPES).addClass('skipped');
    },
    makeYellow: function(element_id) {
        jQuery('#'+element_id+':not(.failed), #'+element_id+':not(.skipped)').removeClass(this.STATUS_TYPES).addClass('pending');
    },
    makeScenario: function(scenario_number, status) {
        jQuery('#scenario_'+ scenario_number).removeClass(this.STATUS_TYPES).addClass(status)
    },
    makeBackground: function(scenario_number, status) {
        jQuery('#background_'+ scenario_number).addClass(status)
    },

    moveProgressBar: function(percentDone) {
        jQuery("#cucumber-header").css('width', percentDone +"%");
    },

    toggleScenarioDetails: function(scenario_item) {
        jQuery(scenario_item).parent().children(this.SCENARIO_DETAILS_LOCATOR).toggle(250);
    },

    toggleScenarioSteps: function(steps_action) {
        if (jQuery(steps_action).text() == 'Show Steps') {
            jQuery(steps_action).text('Hide Steps');
            jQuery(steps_action).parent().parent().children('ol.steps').removeClass('hide-steps');
        } else {
            jQuery(steps_action).text('Show Steps');
            jQuery(steps_action).parent().parent().children('ol.steps').addClass('hide-steps');
        }
    },

    getShowMode: function() {
        return this._showMode;
    },
    setShowMode: function(showMode) {
        this._showMode = showMode
    },
    showAllScenarios: function() {
        jQuery('div.scenario').show();
        this.setShowMode(SagreHtmlReport.SHOW_ALL)
    },
    showOnlyFailedScenarios: function() {
        jQuery('div.scenario.failed').show();
        jQuery('div.scenario:not(.failed)').hide();
        this.setShowMode(SagreHtmlReport.SHOW_ONLY_FAILED)
    },

    showOnlyPassedScenarios: function() {
        jQuery('div.scenario:not(.failed):not(.pending)').show();
        jQuery('div.scenario.failed, div.scenario.pending').hide();
        this.setShowMode(SagreHtmlReport.SHOW_ONLY_PASSED)
    },

    hideRubyCode: function() {
        jQuery(this.rubyCodeSelector).hide()
    },

    showRubyCode: function() {
        jQuery(this.rubyCodeSelector).show()
    },

    toggleAllRubyCode: function() {
        var link_selector = "#toggle-ruby-code-action"

        if (jQuery(link_selector).text() == 'Show Ruby code') {
            jQuery(link_selector).text('Hide Ruby code');
            jQuery(".ruby-action").text('Hide Ruby');
            this.showRubyCode()
        } else {
            jQuery(link_selector).text('Show Ruby code');
            jQuery(".ruby-action").text('Show Ruby');
            this.hideRubyCode()
        }
    },

    toggleRubyCode: function(ruby_action) {
        if (jQuery(ruby_action).text() == 'Show Ruby') {
            jQuery(ruby_action).text('Hide Ruby');
            jQuery(ruby_action).parent().parent().children('.ruby').show();
        } else {
            jQuery(ruby_action).text('Show Ruby');
            jQuery(ruby_action).parent().parent().children('.ruby').hide();
        }
    },

    collapseAll: function() {
        this.allScenariosDetails().hide();
    },
    expandAll: function() {
        this.allScenariosDetails().show();
    },

    allScenariosDetails: function() {
        return $(this.SCENARIOS_LOCATOR).parent().children(this.SCENARIO_DETAILS_LOCATOR)
    },

    expandOnlyFailedScenarios: function() {
        jQuery('div.scenario:not(.failed)').children(this.SCENARIO_DETAILS_LOCATOR).hide();
        jQuery('div.scenario.failed').children(this.SCENARIO_DETAILS_LOCATOR).show();
    },
    expandOnlyPendingScenarios: function() {
        jQuery('div.scenario:not(.pending)').children(this.SCENARIO_DETAILS_LOCATOR).hide();
        jQuery('div.scenario.pending').children(this.SCENARIO_DETAILS_LOCATOR).show();
    },
    expandOnlySuccessfulScenarios: function() {
        jQuery('div.scenario.failed, div.scenario.pending').children(this.SCENARIO_DETAILS_LOCATOR).hide();
        jQuery('div.scenario:not(.failed):not(.pending)').children(this.SCENARIO_DETAILS_LOCATOR).show();
    },

    backtraceSelector: 'div.scenario::visible  div.backtrace, div.background::visible  div.backtrace',
    hideBacktrace: function() {
        jQuery(this.backtraceSelector).hide()
    },
    showBacktrace: function() {
        jQuery('div.scenario::visible  div.backtrace, div.background::visible  div.backtrace').show()
    },

    toggleAllBacktrace: function() {
        var backtraceSelector = '#toggle-backtrace-action';
        if (jQuery(backtraceSelector).text() == 'Show Backtrace') {
            jQuery(backtraceSelector).text('Hide Backtrace');
            jQuery(".backtrace-action").text('Hide Backtrace');
            this.showBacktrace()
        } else {
            jQuery(backtraceSelector).text('Show Backtrace');
            jQuery(".backtrace-action").text('Show Backtrace');
            this.hideBacktrace()
        }
        return false
    },

    toggleBacktrace: function(backtrace_action) {
        if (jQuery(backtrace_action).text() == 'Show Backtrace') {
            jQuery(backtrace_action).text('Hide Backtrace');
            jQuery(backtrace_action).parent().parent().children('.backtrace').show();
        } else {
            jQuery(backtrace_action).text('Show Backtrace');
            jQuery(backtrace_action).parent().parent().children('.backtrace').hide();
        }
    },

    showKnownFails: function() {
        jQuery('div.scenario.failed:has(span.known_bug)').show();
    },

    hideKnownFails: function() {
        jQuery('div.scenario.failed:has(span.known_bug)').hide();
    },

    onlyKnownFailsSelector: '#toggle-known-fails',

    toggleKnownFails: function() {
        if (jQuery(this.onlyKnownFailsSelector).text() == 'Hide known fails') {
            jQuery(this.onlyKnownFailsSelector).text('Show known fails');
            this.hideKnownFails()
        } else {
            jQuery(this.onlyKnownFailsSelector).text('Hide known fails');
            this.showKnownFails()
        }
    },

    showUnknownFails: function() {
        jQuery('div.scenario.failed:not(:has(span.known_bug))').show();
    },
    hideUnknownFails: function() {
        jQuery('div.scenario.failed:not(:has(span.known_bug))').hide();
    },

    unknownFailsSelector: '#toggle-unknown-fails',

    toggleUnknownFails: function() {
        if (jQuery(this.unknownFailsSelector).text() == 'Hide unknown fails') {
            jQuery(this.unknownFailsSelector).text('Show unknown fails');
            this.hideUnknownFails()
        } else {
            jQuery(this.unknownFailsSelector).text('Hide unknown fails');
            this.showUnknownFails()
        }
    }

};

