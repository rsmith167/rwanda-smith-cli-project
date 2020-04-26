require_relative './navigate.rb'
require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'
class StartApp
    @@current_user = ""
    def self.current_user=(current_user)
        @@current_user = current_user
    end
    def self.current_user
        @@current_user
    end
    def initialize
        puts "Greetings\! Welcome to \'Find Your First Hero\'.\nSo, you just bought Overwatch and aren\'t sure which hero to choose for your first match.\nNo problem.\nThis app is designed to help narrow down the myriad of choices Overwatch offers.\n"
        Navigate.new
        WebsiteScraper.new  
        self.class.create_account
    end
    def self.create_account
        puts "\nWhat is your name?\n\n"
        your_name = gets.chomp
        your_name.upcase!
           UserProfiles.new(your_name)
           self.mainmenu
    end
    def self.mainmenu
        puts "\nWhat is the most important thing to you in a hero?\nPlease type in the corrsponding letter and hit enter:\n"
        puts "\nR - Role    H - Help    C - Change user\n"   
        uimostimportant = "" #user input most imporant detail
        uimostimportant = gets.chomp #gets rid of \n
        uimostimportant.upcase! #make the case uppercase incase the user uses lower case letters
        if uimostimportant == "R"
            Navigate.start("R")
        elsif uimostimportant  == "H"
            self.helpmenu
        elsif uimostimportant == "C"
            puts "\nPlease enter your name.\n"
            change_user_name = gets.chomp
            change_user_name.upcase!
            UserProfiles.change_users(change_user_name)
            self.mainmenu
        else
            puts "\nThis is not a valid choice.\n"
           self.mainmenu
        end
    end
    def self.helpmenu
        puts "\nPlease select the corresponding number for your question:\n"
        puts "\n1. What Roles are there?\n2. How do I change users?\n3. How do I navigate this app?\n4. Back to previous screen\n"
        uineedshelp = ""
        uineedshelp = gets.to_i #converts the string the user entered to an actual integer
        if uineedshelp == 1
            puts "\nThe roles are: #{WebsiteScraper.role_or_aff_list("role")}\n\n\n"
            self.helpmenu
        elsif   uineedshelp == 2
            puts "\nOn the main menu, press C to change users.\n"
            self.helpmenu
        elsif  uineedshelp == 3
            puts "\nOn most pages, you can press\m H - to access the Help menu    M - to access the Main menu\nC - to change heroes    ctrl + c - to quit the program.\n"
            puts "\nIf you are unable to do one of the above, please continue with the prompts on the screen.\n"
            self.helpmenu
        elsif uineedshelp == 4
            self.mainmenu
        else
            puts "\nNot a valid option\n\n\n"
            self.helpmenu
        end
    end
end
StartApp.new