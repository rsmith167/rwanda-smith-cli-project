require 'nokogiri'
require 'open-uri'
class WebsiteScraper
    #the purpose of this is to pull all hero names from https://playoverwatch.com/en-us/heroes
    #then go to the heros' webpages and pull the name, occupation, base, and affiliation
    
    @@all_hero_names = []
    @@all_role_types = []
    @@all_affiliation_types = []
    @@all_heroes = {}
   def initialize
    doc1 = Nokogiri::HTML(open("https://playoverwatch.com/en-us/heroes")) #make a list of all heros and their attributes
    hero_array = doc1.css(".hero-portrait-detailed")
    hero_array.each { |hero_xml| 
            ph1 = hero_xml.text #hero name from main page            
            if ph1 == "D.Va" #a few heros have special characters that are not equal to their URL slug
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
            ph1.downcase!
            @@all_hero_names << ph1
            @@all_heroes[ph1] = {}
            ph2 = "https://playoverwatch.com/en-us/heroes/" + ph1
            doc2 = Nokogiri::HTML(open(ph2)) #go to heroes page
            @@all_role_types << doc2.css(".h2").text #HERO ROLE
            @@all_heroes[ph1]["role"] = doc2.css(".h2").text
            @@all_heroes[ph1]["name"] = doc2.css(".hero-bio").css(".name").text
            @@all_heroes[ph1]["occupation"] = doc2.css(".hero-bio").css(".occupation").text
            @@all_heroes[ph1]["base"] = doc2.css(".hero-bio").css(".base").text
            @@all_affiliation_types << doc2.css(".hero-bio").css(".affiliation").text
            @@all_heroes[ph1]["affiliation"] = doc2.css(".hero-bio").css(".affiliation").text
            @@all_heroes[ph1]["description"] = doc2.css(".hero-detail-description").text
            @@all_heroes[ph1]["bio"] = doc2.css(".hero-bio-backstory").text
            }
            self.class.roles_clean
            self.class.affiliation_clean
        end
        def self.roles_clean
            @@all_role_types = @@all_role_types.collect {|x| x}.uniq            
        end
        def self.affiliation_clean
            @@all_affiliation_types = @@all_affiliation_types.collect {|x| x}.uniq            
        end
        # def self.roles_list
        #     @@all_role_types
        # end
        # def self.affiliation_list
        #     @@all_affiliation_types
        #end
        def self.role_or_aff_list(role_or_aff)
           if role_or_aff == "role" 
                @@all_role_types
            elsif role_or_aff == "affiliation"
                @@all_affiliation_types
            end
        end
        def self.all_heroes
            @@all_heroes
        end
        def self.all_hero_names
            @@all_hero_names
        end
        def self.list_heroes_by_role(role_or_aff)
           list_hero_array = []
           if self.roles_list.include?(role_or_aff)
                self.all_hero_names.each {|x| 
                if self.all_heroes[x]["role"] == role_or_aff
                    list_hero_array << x
                end}
            elsif self.affiliation_list.include?(role_or_aff)
                self.all_hero_names.each {|x| 
                    if self.all_heroes[x]["affiliation"] == role_or_aff
                        list_hero_array << x
                    end}
                end
            list_hero_array
        end

end