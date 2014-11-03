# ---+ Extensions
# ---++ JQueryPlugin
# ---+++ Extra plugins

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngCore}{Module} = 'Foswiki::Plugins::AngularPlugin::Core';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngCore}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngAnimate}{Module} = 'Foswiki::Plugins::AngularPlugin::Animate';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngAnimate}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngAria}{Module} = 'Foswiki::Plugins::AngularPlugin::Aria';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngAria}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngCookies}{Module} = 'Foswiki::Plugins::AngularPlugin::Cookies';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngCookues}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngLoader}{Module} = 'Foswiki::Plugins::AngularPlugin::Loader';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngLoader}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngMessages}{Module} = 'Foswiki::Plugins::AngularPlugin::Messages';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngMessages}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngMocks}{Module} = 'Foswiki::Plugins::AngularPlugin::Mocks';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngMocks}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngResource}{Module} = 'Foswiki::Plugins::AngularPlugin::Resource';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngResource}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngRoute}{Module} = 'Foswiki::Plugins::AngularPlugin::Route';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngRoute}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngSanitize}{Module} = 'Foswiki::Plugins::AngularPlugin::Sanitize';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngSanitize}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngScenario}{Module} = 'Foswiki::Plugins::AngularPlugin::Scenario';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngScenario}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngTouch}{Module} = 'Foswiki::Plugins::AngularPlugin::Touch';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngTouch}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngFx}{Module} = 'Foswiki::Plugins::AngularPlugin::Fx';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{ngFx}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{loadingBar}{Module} = 'Foswiki::Plugins::AngularPlugin::LoadingBar';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{loadingBar}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{AngularPlugin}{Modules}{"ui.knob"}{Module} = 'Foswiki::Plugins::AngularPlugin::Knob';
# **BOOLEAN**
$Foswiki::cfg{AngularPlugin}{Modules}{"ui.knob"}{Enabled} = 1;

# **STRING**
$Foswiki::cfg{AngularPlugin}{Modules}{"ui.slider"}{Module} = 'Foswiki::Plugins::AngularPlugin::Slider';

# **BOOLEAN**
$Foswiki::cfg{AngularPlugin}{Modules}{"ui.slider"}{Enabled} = 1;

# **BOOLEAN**
$Foswiki::cfg{AngularPlugin}{Html5Mode} = 1;

# **PERL**
$Foswiki::cfg{SwitchBoard}{angular} = {
    package  => 'Foswiki::Plugins::AngularPlugin',
    function => 'dispatch',
    context  => {
        angular => 1
    }
};
