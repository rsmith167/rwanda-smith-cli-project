require 'nokogiri'
require 'open-uri'
class WebsiteScraper
    #the purpose of this is to pull all of the heroes' names from https://playoverwatch.com/en-us/heroes
    #then go to each of the heroes webpages and pulls their name, occupation, base, affiliation, bio, and description
    #it does this once when StartApp.new is called    
    @@all_hero_names = []
    @@all_role_types = []
    @@all_affiliation_types = []
    @@all_heroes = {}
   def initialize
    doc1 = Nokogiri::HTML(open("https://playoverwatch.com/en-us/heroes")) #make a list of all heroes' names
    hero_array = doc1.css(".hero-portrait-detailed") #the attribute that narrows doc1 to just the list of heroes so I can get their names
    hero_array.each { |hero_xml| 
            ph1 = hero_xml.text #hero name from main page...ph1 = placeholder       
            if ph1 == "D.Va" #a few heros have special characters that are not equal to their URL slug. I hardcoded these, but I recognize if a new hero is added that has a special character, I will then need to update this code
                ph1 = "dva"
            elsif ph1 == "Lúcio"
                ph1 = "lucio"
            elsif ph1 == "Soldier: 76"
                ph1 = "soldier-76"
            elsif ph1 == "Torbjörn"
                ph1 = "torbjorn"
            elsif ph1 == "Wrecking Ball"
                ph1 = "wrecking-ball"
            end
            ph1.downcase! #the slugs for the heroes' urls are their name in lowercase
            @@all_hero_names << ph1
            @@all_heroes[ph1] = {} #creating a hash so that I can look up a bunch of different info by hero name
            ph2 = "https://playoverwatch.com/en-us/heroes/" + ph1 #now we are going to each heroes' individual webpage
            doc2 = Nokogiri::HTML(open(ph2)) #go to heroes page
            @@all_heroes[ph1]["role"] = doc2.css(".h2").text #pull's hero's role
            @@all_role_types <<  @@all_heroes[ph1]["role"]
            @@all_heroes[ph1]["name"] = doc2.css(".hero-bio").css(".name").text
            @@all_heroes[ph1]["occupation"] = doc2.css(".hero-bio").css(".occupation").text
            @@all_heroes[ph1]["base"] = doc2.css(".hero-bio").css(".base").text            
            @@all_heroes[ph1]["affiliation"] = doc2.css(".hero-bio").css(".affiliation").text
            @@all_affiliation_types << @@all_heroes[ph1]["affiliation"]
            @@all_heroes[ph1]["description"] = doc2.css(".hero-detail-description").text
            @@all_heroes[ph1]["bio"] = doc2.css(".hero-bio-backstory").text
            }
            self.class.clean #I just shoved each hero's role and aff into an array, so now I am getting the unique values
        end
        def self.clean
            @@all_role_types = @@all_role_types.collect {|x| x}.uniq  
            @@all_affiliation_types = @@all_affiliation_types.collect {|x| x}.uniq          
        end
        def self.role_or_aff_list(role_or_aff)
             if role_or_aff == "role" 
                @@all_role_types #implicit return value since it is the last item of the code it will be returned. Did not use the return keyword
            elsif role_or_aff == "affiliation"
                @@all_affiliation_types
            end
        end
        def self.all_heroes
            @@all_heroes #this is the hash of everything
        end
        def self.all_hero_names
            @@all_hero_names #this is just an aray of all name
        end
        def self.list_heroes_by(role_or_aff) #I am not sure if this is better than creating a module for sorting, this extending those methods to a class for Role and a class for Affiliation. I felt like that was lenghting the code, so I just made this class method in WebsiteScraper. I though it made sense because this class pulls the data, stores it, cleans it, and groups it up
           list_hero_array = []
           if self.role_or_aff_list("role").include?(role_or_aff)
                self.all_hero_names.each {|x| 
                if self.all_heroes[x]["role"] == role_or_aff
                    list_hero_array << x
                end}
            else 
                self.all_hero_names.each {|x| 
                    if self.all_heroes[x]["affiliation"] == role_or_aff
                        list_hero_array << x
                    end}
                end
            list_hero_array #implicit return
        end
        def self.narrow_heroes_by(hero_list, role_or_aff)
            hero_narrow = []
            self.all_hero_names.each {
                |hero_name|
                if hero_list.include?(hero_name) && self.role_or_aff_list("role").include?(role_or_aff)
                    hero_narrow << self.all_heroes[hero_name]["affiliation"]
                elsif hero_list.include?(hero_name) && self.role_or_aff_list("affiliation").include?(role_or_aff)
                    hero_narrow << self.all_heroes[hero_name]["role"]
                end
            }
            return hero_narrow #explicit return
        end
end