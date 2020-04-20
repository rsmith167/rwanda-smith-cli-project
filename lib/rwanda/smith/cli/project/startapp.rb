
require_relative './navigate.rb'
require_relative './userprofile.rb'
require_relative './WebsiteScraper.rb'

class StartApp
    attr_reader :current_user
    def initialize
        puts "Greetings\! Welcome to \'Find Your First Hero\'.\nSo, you just bought Overwatch and aren\'t sure which hero to choose for your first match.\nNo problem.\nThis app is designed to help narrow down the myriad of choices Overwatch offers.\n"
        Navigate.new
        puts "Loading data...Please wait 30 seconds"
        WebsiteScraper.new  
        self.create_account
    end
    def self.create_account
        puts "What is your name?"
        your_name = gets.chomp
        your_name.upcase!
        if UserProfiles.new(your_name) == "Fail"
            puts "If you already have an account, please enter your name. If you do not have an account, press 1."
            answer = gets.chomp
            answer.upcase!
            if answer.to_i == 1
                self.create_account
            elsif UserProfiles.all_users.include?(answer)
                @current_user = answer
                self.mainmenu
            else
                puts "What you typed in is still invalid. Please try again. Your name is not case sensitive, but it must be spelled correctly"
                self.create_account
            end
        else
            UserProfiles.new(your_name)
            @current_user = your_name
           self.mainmenu
        end
    end
    def self.mainmenu
        puts "What is the most important thing to you in a hero?\nPlease type in the corrsponding letter and hit enter:"
        puts "R - Role    A - Affiliation    H - Help    C - Change user"
        uimostimportant = "" #user input most imporant detail
        uimostimportant = gets.chomp #gets rid of \n
        uimostimportant.upcase! #make the case uppercase incase the user uses lower case letters
        if uimostimportant == "R"
            Navigate.start("R")
        elsif uimostimportant  == "A"
            Navigate.start("A")
        elsif uimostimportant  == "H"
            self.helpmenu
        elsif uimostimportant == "C"
            puts "Please enter your name."
            change_user_name = gets.chomp.upcase!
            UserProfiles.change_users(change_user_name)
            puts "user has been changed to #{StartApp.current_user}"
            self.mainmenu
        else
            puts "This is not a valid choice."
           self.mainmenu
        end
    end

    def self.helpmenu
        puts "Please select the corresponding number for your question:"
        puts "1. What Roles are there?\n2. What Affiliations are there?\n3. How do I change users?\n4. How do I navigate this app?\n5. Back to previous screen"
        uineedshelp = ""
        uineedshelp = gets.to_i #converts the string the user entered to an actual integer
        if uineedshelp == 1
            puts "The roles are: #{WebsiteScraper.role_or_aff_list("role")}\n\n\n"
            self.helpmenu
        elsif uineedshelp  == 2
            puts "The Affiliations are "
            WebsiteScraper.role_or_aff_list("affiliation").each {|x| puts "#{x}\t\t"}
            self.helpmenu
        elsif   uineedshelp == 3
            puts "On the main menu, press C to change users."
            self.helpmenu
        elsif  uineedshelp == 4
            puts "On most pages, you can press\m H - to access the Help menu    M - to access the Main menu\nC - to change heroes    esc - to quit the program."
            puts "If you are unable to do one of the above, please continue with the prompts on the screen."
            self.helpmenu
        elsif uineedshelp == 5
            self.mainmenu
        else
            puts "Not a valid option\n\n\n"
            self.helpmenu
        end
    end
end
StartApp.new