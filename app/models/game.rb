class Game < ApplicationRecord
  
  # TODO: add validations for emojis & answers

  # 100 emojis that can be eaten
  EDIBLES = [
    "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฅญ", "๐", "๐", "๐", "๐", "๐", "๐ซ", "๐ฅ", "๐", "๐ซ", "๐ฅฅ", "๐ฅ", "๐", "๐ฅ", "๐ฅ", "๐ฝ", "๐ซ", "๐ฅ", "๐ฅฌ", "๐ฅฆ", "๐ง", "๐ง", "๐", "๐ฅ", "๐ฐ", "๐", "๐ฅ", "๐ฅ", "๐ซ", "๐ฅจ", "๐ฅฏ", "๐ฅ", "๐ง", "๐ง", "๐", "๐", "๐ฅฉ", "๐ฅ", "๐", "๐", "๐", "๐ญ", "๐ฅช", "๐ฎ", "๐ฏ", "๐ซ", "๐ฅ", "๐ง", "๐ฅ", "๐ฒ", "๐ซ", "๐ฅ", "๐ฟ", "๐ง", "๐ฅซ", "๐ฑ", "๐", "๐", "๐", "๐", "๐", "๐", "๐ ", "๐ข", "๐ฃ", "๐ค", "๐ฅ", "๐ฅฎ", "๐ก", "๐ฅ", "๐ฅ ", "๐ฅก", "๐ฆช", "๐ฆ", "๐ง", "๐จ", "๐ฉ", "๐ช", "๐ฐ", "๐ง", "๐ฅง", "๐ซ", "๐ฌ", "๐ญ", "๐ฎ", "๐ฏ", "๐ฅ", "โ", "๐ต", "๐ง", "๐ง", "๐ง", "๐ง"
  ].freeze
  
  # 100 emojis you can't eat
  INEDIBLES = [
    "๐", "๐ฃ", "๐ช", "๐บ", "๐งญ", "๐งฑ", "๐", "๐งณ", "โณ", "โฐ", "๐งจ", "๐", "๐", "๐งง", "๐", "๐", "๐คฟ", "๐ช", "๐ฎ", "๐ช", "๐งฟ", "๐งธ", "๐ช", "๐ช", "๐งต", "๐งถ", "๐ฟ", "๐", "๐ฏ", "๐ป", "๐ช", "๐ฑ", "๐", "๐", "๐ป", "๐พ", "๐", "๐งฎ", "๐ฅ", "๐บ", "๐ท", "๐น", "๐ผ", "๐", "๐ก", "๐ฆ", "๐ฎ", "๐ช", "๐", "๐", "๐", "๐ฐ", "๐ต", "๐ณ", "๐ฆ", "๐", "๐", "๐", "๐", "๐จ", "๐ช", "๐ช", "๐ช", "๐ง", "๐ฉ", "๐", "๐ช", "๐งฐ", "๐งฒ", "๐ช", "๐ฌ", "๐ญ", "๐ก", "๐ฉน", "๐ช", "๐ฝ", "๐ช ", "๐", "๐ช", "๐งด", "๐งน", "๐งบ", "๐งป", "๐ชฃ", "๐งผ", "๐ชฅ", "๐งฝ", "๐งฏ", "๐ฟ", "๐", "๐", "๐ผ", "๐ฎ", "๐ฒ", "๐", "๐", "๐", "๐ถ", "๐ธ", "๐ต"
  ].freeze
  
  # All games which have been completed and scored
  scope :scored, lambda { where("#{table_name}.score IS NOT NULL && #{table_name}.duration IS NOT NULL") }
  
  # Scored games sorted by leaderboard rank
  scope :ranked, lambda { Game.scored.order(score: :desc).order(duration: :asc) }
  
  # Sets up new game board of 30 edible/inedible emojis and creates a true/false string of answers
  def new_game_set
    emojis = ""
    answers = ""
    
    # Choose 30 random emojis from the 200 objects and create true/false string of whether each is edible
    (0...30).each do
      item = rand(0..1)
      if item == 0
        emojis << INEDIBLES.sample
        answers << "0"
      else
        emojis << EDIBLES.sample
        answers << "1"
      end
    end
    
    # Load object with new game set
    self.emojis = emojis
    self.answers = answers
    self.responses = ""
  end
  
  # Calculate score for complete games
  def calculate_score!
    if self.responses.length == 30
      score = 0
      self.answers.split("").each_with_index do |char, index|
        if self.responses[index] == char
          score += 1
        end
      end
      self.score = score
      self.save
    end
  end
  
  # Calculate time to finish for complete games
  def calculate_duration!
    unless self.finished_at.nil? || self.started_at.nil?
      self.duration = self.finished_at - self.started_at
      self.save
    end
  end
end
