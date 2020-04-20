#the method is the beginning of the app
require_relative './choserole.rb'
require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'
#ruby lib/rwanda/smith/cli/project/startapp.rb
class StartApp
    def initialize
        puts "Greetings\! Welcome to \'Find Your First Hero\'.\nSo, you just bought Overwatch and aren\'t sure which hero to choose for your first match.\nNo problem.\nThis app is designed to help narrow down the myriad of choices Overwatch offers.\n"
        UserProfiles.new
        ChoseRole.new
        puts "Loading data...Please wait 30 seconds"
        WebsiteScraper.new        
        self.class.mainmenu
    end
    def self.mainmenu
        puts "What is the most important thing to you in a hero?\nPlease type in the corrsponding letter and hit enter:"
        puts "R - Role    A - Affiliation    H - Help"
        uimostimportant = ""
        uimostimportant = gets.chomp #user input most imporant detail
        uimostimportant.upcase! #make the case uppercase incase the user uses lower case letters
        if uimostimportant == "R"
            ChoseRole.start("R")
        elsif uimostimportant  == "A"
            ChoseRole.start("A")
        elsif uimostimportant  == "H"
            self.helpmenu
        else
            puts "This is not a valid choice."
           self.mainmenu
        end
    end

    def self.helpmenu
        puts "Please select the corresponding number for your question:"
        puts "1. What Roles are there?\n2. What Affiliations are there?\n3. Back to previous screen"
        uineedshelp = ""
        uineedshelp = gets.to_i
        if uineedshelp == 1
            puts "The roles are: #{WebsiteScraper.role_or_aff_list("role")}\n\n\n"
            self.helpmenu
        elsif uineedshelp  == 2
            puts "The Affiliations are "
            WebsiteScraper.role_or_aff_list("affiliation").each {|x| puts "#{x}\t\t"}
            self.helpmenu
        elsif uineedshelp == 3
           self.mainmenu
        else
            puts "Not a valid option\n\n\n"
            self.helpmenu
        end
    end
end
 StartApp.new 