require 'open-uri'

def parse(page)
    page = page.gsub("User:","")
    page = page.gsub("Release Date:","")
    page = page.gsub(/<.*?>/,"")
    page = page.rstrip()
    page = page.gsub("\n", "@")
    page = page.gsub("  ", "")

    page = page.squeeze("@")
    page = page.split("@")

    newpage = []

    for i in 4..page.length
        if i % 4 == 0 and page[i-1] != "tbd"
            temparr = []
            temparr.push(page[i-3])
            temparr.push(page[i-2].to_f)
            temparr.push(page[i-1].to_f * 10)
            temparr.push((temparr[2] / temparr[1]).round(2))
            newpage.push(temparr)
        end
    end

    return newpage
end

def rank(games)
    sorted = games.sort! {|a,b| b[3] <=> a[3]}
    
    puts "User-favoured games: (high user vs. critic %)"
    for i in 0..9
        print (i+1), ") ", sorted[i][0], ": ", (sorted[i][3] * 100).round(2), "\%\n"
    end

    puts "\nCritic-favoured games: (low user vs. critic %)"
    for i in (sorted.length-1).downto(sorted.length - 10)
        print (sorted.length - i), ") ", sorted[i][0], ": ", (sorted[i][3] * 100).round(2), "\%\n"
    end

    print "\nTotal number of games: ", sorted.length, "\n"

    puts "\n"

end

def get(url)
    file = open(url)
    page = file.read

    startmark = '<ol class="list_products list_product_condensed">'
    page = page.slice(page.index(startmark)..-1)
    page = page.slice(0..(page.index('</ol>')))

    games = parse(page)

    rank(games)

    return page
end

def ask_type()
    puts "Movies, TV, games or music?"
    type = gets.chomp().downcase()

    if ["movies", "movie"].include?(type)
        type = "movies"
    elsif ["tv", "television"].include?(type)
        type = "tv"
    elsif ["games", "game", "video games"].include?(type)
        type = "games"
    elsif ["music", "songs", "albums"].include?(type)
        type = "albums"
    else
        puts "Unrecognised input!"
        ask_type()
    end

    return type
end

def ask_plat()
    puts "Which platform do you want to look at?"
    platform = gets.chomp().downcase()

    if ["ps4", "playstation 4", "playstation4"].include?(platform)
        platform = "ps4"
    elsif ["xboxone", "xbox 1", "xbox one", "xbone"].include?(platform)
        platform = "xboxone"
    elsif ["ps3", "playstation 3", "playstation3"].include?(platform)
        platform = "ps3"
    elsif ["x360", "xbox360", "xbox 360"].include?(platform)
        platform = "xbox360"
    elsif ["pc"].include?(platform)
        platform = "pc"
    elsif ["wii-u", "wii u", "wii"].include?(platform)
        platform = "wii-u"
    elsif ["3ds", "ds"].include?(platform)
        platform = "3ds"
    elsif ["ps vita", "psv", "psvita"].include?(platform)
        platform = "vita"
    elsif ["ios", "iphone"].include?(platform)
        platform = "ios"
    elsif ["ps2", "playstation2", "playstation 2"].include?(platform)
        platform = "ps2"
    else
        puts "Unrecognised input!"
        ask_plat()
    end

    return platform
end

def ask_time()
    puts "Recently or all time?"
    time = gets.chomp().downcase()

    if ["recent", "recently"].include?(time)
        time = "90day"
    elsif ["all time", "all", "alltime"].include?(time)
        time = "all"
    else
        puts "Unrecognised input!"
        ask_time()
    end

    return time
end

def ask()
    # typefill = ask_type()
    typefill = "games"
    
    if typefill == "games"
        platfill = ask_plat()
    else
        platfill = ""
    end

    timefill = ask_time()

    url = "http://www.metacritic.com/browse/" + typefill + "/score/metascore/" + timefill + "/" + platfill

    get(url)
end

ask()
