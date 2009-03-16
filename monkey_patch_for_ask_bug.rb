# Workaround for bug described here:
# http://rails.lighthouseapp.com/projects/8994/tickets/1655-ask-not-working-in-templaterunner-through-rake-railstemplate
# Pratik, for some reason, has marked it as "invalid".  FML.

module Rails
  class TemplateRunner
    def ask(string)
      log '', string
      STDIN.gets.strip
    end
  end
end
