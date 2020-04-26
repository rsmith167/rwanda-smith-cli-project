
class UserProfiles
    @@all_users = []
    attr_reader :your_hero_list, :name #just a reader macro, you can't change your name at all
    def initialize(name)
        if !@@all_users.include?(name)
                @name = name
                @your_hero_list = []
                @@all_users << self  
                StartApp.current_user = self
        else 
            puts "\nName already taken.\n"  
            return "Fail"
        end
    end
    def self.change_users(not_current_user)
        if StartApp.current_user.name == not_current_user
            puts "\nYou are already the active user.\n"
        else
            if  self.all_users.any? {|user| user.name == not_current_user}
                StartApp.current_user = self.all_users.find { |user| user.name == not_current_user}
                puts "\nUser has been changed to #{StartApp.current_user.name}\n"
            else
                StartApp.current_user = self.new(not_current_user)  
                puts "\nA new profile has been created for you and the current user is now #{StartApp.current_user.name}.\n"
             end
        end
    end
    def save_a_hero(hero_name)
        if !@your_hero_list.include?(hero_name)
        @your_hero_list << hero_name
        end
    end
    def self.all_users
        @@all_users
    end
    def view_your_list
        hero_details = {1 => "role", 2 => "name", 3 => "occupation", 4 => "base", 5 => "affiliation", 6 => "description", 7 => "bio"}
        hero_index = {}
        @your_hero_list.each_with_index{|hero_name, index|
            hero_index[index] = hero_name
            puts "\nPress #{index+1} to select #{hero_name}\n"}
        uiuserlist = ""
        uiuserlist = gets.chomp
        if uiuserlist.upcase == "M"
            StartApp.mainmenu
        elsif hero_index[uiuserlist.to_i - 1] != nil
            puts "\nWhat would you like to view\n1. Role    2. Name            3. Occupation\n4. Base    5. Affiliation     6. Description\n7. Bio    8 - Delete from list\n"
            uilistselect = 0
            uilistselect = gets.to_i
            if uilistselect == 8
                self.your_hero_list.delete_at(uiuserlist.to_i - 1)
            else
            puts "#{WebsiteScraper.all_heroes[hero_index[uiuserlist.to_i - 1]][hero_details[uilistselect]]}\n\n"
            end
            puts "\nPress any key to view all heroes.\n"
            gets
            self.view_your_list
            
        else
            puts "\nNot a valid choice.\n"
            self.view_your_list
        end
    end
end