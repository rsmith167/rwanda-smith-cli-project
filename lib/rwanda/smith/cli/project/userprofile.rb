
class UserProfiles
    @@all_users = []
    attr_reader :your_hero_list
    def initialize()
        @your_hero_list = []
        @@all_users << self
        
    end
    def save_a_hero(hero_name)
        @your_hero_list << hero_name
    end
    def self.all_users
        @@all_users
    end
    def view_your_list
        hero_details = {1 => "role", 2 => "name", 3 => "occupation", 4 => "base", 5 => "affiliation", 6 => "description", 7 => "bio"}
        hero_index = {}
        @@all_users[0].your_hero_list.each_with_index{|hero_name, index|
            hero_index[index] = hero_name
            puts "Press #{index+1} to select #{hero_name}"}
        uiuserlist = ""
        uiuserlist = gets.chomp
        if uiuserlist.upcase == "M"
            StartApp.mainmenu
        elsif hero_index[uiuserlist.to_i - 1] != nil
            puts "What would you like to view\n1. Role    2. Name            3. Occupation\n4. Base    5. Affiliation     6. Description\n7. Bio    8 - Delete from list"
            uilistselect = 0
            uilistselect = gets.to_i
            if uilistselect == 8
                self.class.all_users[0].your_hero_list.delete_at(uiuserlist.to_i - 1)
            else
            puts "#{WebsiteScraper.all_heroes[hero_index[uiuserlist.to_i - 1]][hero_details[uilistselect]]}\n\n"
            end
            puts "Press any key to view all heroes"
            gets
           @@all_users[0].view_your_list
            
        else
            puts "Not a valid choice"
            @@all_users[0].view_your_list
        end
    end
    

end