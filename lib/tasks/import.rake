namespace :import do
  
  desc "populate database with data from sectors.csv"
  task :add_sectors => :environment do
    lines = File.new('public/data/sectors.csv').readlines
    header = lines.shift.strip
    keys = header.split(',')
    lines.each do |line|
      params = {}
      values = line.strip.split(',')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Sector.create(params)
    end
  end
  
  desc "populate database with data from occupations.csv"
  task :add_occupations => :environment do
    lines = File.new('public/data/occupations.csv').readlines
    header = lines.shift.strip
    keys = header.split(',')
    lines.each do |line|
      params = {}
      values = line.strip.split(',')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Occupation.create(params)
    end
  end
  
  desc "populate database with data from qualities.csv"
  task :add_qualities => :environment do
    lines = File.new('public/data/qualities.csv').readlines
    header = lines.shift.strip
    keys = header.split(',')
    lines.each do |line|
      params = {}
      values = line.strip.split(',')
      keys.each_with_index do |key, i|
        params[key] = values[i]
      end
      Quality.create(params)
    end
  end
  
  desc "update PAMs with data from pams3.csv"
  task :update_pams => :environment do
    lines = File.new('public/data/pams3.csv').readlines
    header = lines.shift.strip
    keys = header.split(';')
    lines.each do |line|
      params = {}
      values = line.strip.split(';')
      
      @qlt = values[0]
      @grade = values[1]
      @descriptor = values[2]
      @quality = Quality.find_by_quality(@qlt)
      unless @quality == nil
        @pam = Pam.find_by_quality_id_and_grade(@quality.id, @grade)
        @pam.update_attributes(:descriptor => @descriptor, :approved => true)
      end
    end
  end
  
  desc "Run all import tasks"
  task :all => [:add_sectors, :add_occupations, :add_qualities, :update_pams]
end
