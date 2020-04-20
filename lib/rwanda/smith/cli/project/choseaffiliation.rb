class ChoseAffiliation

    # def initialize(ws)
    #    ws = ws 
    #     puts "The affiliations are #{ws.afiiliation_clean}"
    # end
    def start
        @ws = WebsiteScraper
        puts "The roles are #{@ws.roles_list}"
        puts "Press    #{@ws.roles_list[0][0]} - #{@ws.roles_list[0]}    #{@ws.roles_list[1][0]} - #{@ws.roles_list[1]}    #{@ws.roles_list[2][0]} - #{@ws.roles_list[2]}   
        \n\t\tM - Main Menu    H - Help"
        uichoseroles = ""
        uichoseroles = gets.chomp
        uichoseroles.upcase!
        if uichoseroles  == "T"
            choosebasedonrole("Tank")  
        elsif uichoseroles  == "D"
            choosebasedonrole("Damage")  
        elsif uichoseroles  == "S"
            choosebasedonrole("Support")  
        elsif uichoseroles == "M"
            StartApp.mainmenu
        elsif uichoseroles  == "H"
            StartApp.helpmenu
        else
            puts "\nThis is not a valid option"
            start
        end
    end
end