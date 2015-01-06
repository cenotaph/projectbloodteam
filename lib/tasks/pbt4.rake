require 'open-uri'
require 'discogs'
def grabURL(url, home)
  require 'open-uri'
  open(home,"w").write(open(url).read)
end

namespace :pbt do
  desc "PBT stuff"

  task :get_updated_movies => [:environment] do
    MasterMovie.where("audited is false and imdbcode is not null").each do |mm|
      begin
        mm.resync_imdb_image
        mm.title.strip!
        mm.country.strip!
        mm.country.gsub!(/\n/, '')
        m = Imdb::Movie.new(mm.imdbcode)
        unless m.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }.nil?
          mm.english_title = m.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }[:title]
        end
        unless m.also_known_as.find{|x| x[:version] == '(original title)' }.nil?
          mm.title = m.also_known_as.find{|x| x[:version] == '(original title)' }[:title]
        end
        mm.audited = true
        puts "audited #{mm.title}"
        mm.save!  
      rescue
        next
      end  
    end
  end
  
  task :get_discogs_masters => [:environment] do
    wrapper = Discogs::Wrapper.new('f6d728eef1')
    allmusic = MasterMusic.where(:converted => false)
    
    allmusic.each do |am|
      if am.musics.empty?
        am.destroy!
        next
      end
      next if am.discogscode.blank?
      begin
        r = wrapper.get_release(am.discogscode)
      rescue Discogs::UnknownResource
        puts 'Error '
        next
      end
      am.masterdiscogs_id = r.master_id
      am.converted = true
      am.save!
      puts 'Converted ' + r.artists.map(&:name).join(', ') + " / " + r.title.to_s
    end
      
  end
  
  task :missing_music => [:environment] do
    MasterMusic.where(:filename_file_name => nil).where('discogscode is not null').reverse.each do |mm|
      next if mm.discogscode.blank?
      next if mm.discogscode == 0 || mm.discogscode == '0'
      m = Discogs::Wrapper.new('f6d728eef1').get_release(mm.discogscode) rescue next
      unless m.nil?
        require 'open-uri'
        require 'cgi'
        unless m.images.blank?
          mm.filename_file_name = CGI.escape(mm.discogscode.to_s + '.jpg')
          system("mkdir -p " + RAILS_ROOT + '/public/images/master_musics/' + mm.id.to_s + "/thumb")
          system("mkdir -p " + RAILS_ROOT + '/public/images/master_musics/' + mm.id.to_s + "/full")
          open(RAILS_ROOT+'/public/images/master_musics/' + mm.id.to_s + '/thumb/' + mm.filename_file_name, "wb").write(open(m.images.first.uri150).read) rescue nil
          open(RAILS_ROOT+'/public/images/master_musics/' + mm.id.to_s + '/full/' + mm.discogscode.to_s + '.jpg', "wb").write(open(m.images.first.uri).read) rescue nil
          mm.save!
        end
      end
    end
  end

  task :get_profiles => [:environment] do
    Profile.all.each do |profile|
      next if profile.imageurl.blank?
      filename = profile.imageurl.match(/([^\/]+)(\?.+)*$/)[1]
      system('mkdir -p ' + RAILS_ROOT + "/public/images/agents/#{profile.id.to_s}/small")
      system('mkdir -p ' + RAILS_ROOT + "/public/images/agents/#{profile.id.to_s}/thumb")
      puts "attempting to fetch #{profile.imageurl}"
      grabURL(profile.imageurl, RAILS_ROOT + "/public/images/agents/#{profile.id.to_s}/#{filename}") rescue next
      if profile.imageurl =~ /jpg$/i 
        content_type = 'image/jpeg'
      elsif profile.imageurl =~ /png$/i
        content_type = 'image/png'
      elsif profile.imageurl =~ /gif$/i
        content_type = 'image/gif'
      else
        content_type = 'unknown'
      end
      profile.avatar_file_name = filename
      profile.avatar_file_size = File.stat(RAILS_ROOT + "/public/images/agents/#{profile.id.to_s}/#{filename}").size
      next if profile.avatar_file_size == 0
      profile.avatar_content_type = content_type
      profile.avatar_updated_at = File.stat(RAILS_ROOT + "/public/images/agents/#{profile.id.to_s}/#{filename}").mtime
      profile.save!
      # sleep 4
      # system("convert #{RAILS_ROOT}/public/images/agents/#{profile.id.to_s}/#{filename} -thumbnail '150x150>' #{RAILS_ROOT}/public/images/agents/#{profile.id.to_s}/thumb/#{filename}")
      # sleep 3
      # system("convert #{RAILS_ROOT}/public/images/agents/#{profile.id.to_s}/#{filename} -thumbnail '75x75^' -gravity center -extent 75x75 #{RAILS_ROOT}/public/images/agents/#{profile.id.to_s}/small/#{filename}")
      # sleep 3
    end
  end
  
  task :migrate_to_paperclip => [:environment] do
    [Activity, Airport, Bar, Book, Brewing, Concert, Eating, Event, Exercise,
    Gambling, Grocery, Mile, Movie, Music, Musicplayed, Restaurant, Takeaway,
    Videogame, Weight].each do |category|
        category.find(:all).each do |entry|

          next if entry.userimage.blank?
          if File.exists?(RAILS_ROOT + "/public/images/#{category.table_name}/#{entry.id.to_s}/#{entry.userimage}")
            ## it exists, so
            if entry.userimage =~ /jpg$/i 
              content_type = 'image/jpeg'
            elsif entry.userimage =~ /png$/i
              content_type = 'image/png'
            elsif entry.userimage =~ /gif$/i
              content_type = 'image/gif'
            else
              content_type = 'unknown'
            end
            size = File.stat(RAILS_ROOT + "/public/images/#{category.table_name}/#{entry.id.to_s}/#{entry.userimage}").size
            updated = File.stat(RAILS_ROOT + "/public/images/#{category.table_name}/#{entry.id.to_s}/#{entry.userimage}").mtime
            Userimage.create(:entry_id => entry.id, :entry_type => category.to_s, :image_file_name => entry.userimage,
              :image_content_type => content_type, :image_file_size => size,  :image_updated_at => updated, :primary => true)

          end
        end
    end
  end
  

end