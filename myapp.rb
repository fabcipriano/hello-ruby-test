# myapp.rb
class Song
    def initialize (name, artist, duration)
        @name = name
        @artist = artist
        @duration = duration
    end

    def to_s
        "Song: #{@name} -- #{@artist} (#{@duration})"
    end
end

class SongReader
    def initialize(filename)
        @filename = filename
        @songs = Array.new
    end

    def read_song_list
        songFile = File.new(@filename)
        songFile.each do |line|
            file, length, name, title = line.chomp.split(/\s*\|\s*/)
            @songs.push Song.new(title, name, length)
        end
    end

    def print_songs
        @songs.each do |e|
            puts e.to_s
        end
    end

end

sr = SongReader.new("./songs.txt")

sr.read_song_list

sr.print_songs

puts "Hello World!!!"

puts "Done" 