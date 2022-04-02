class Game < ApplicationRecord
  
  # TODO: add validations for emojis & answers

  # 100 emojis that can be eaten
  EDIBLES = [
    "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍐", "🍑", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄", "🥜", "🌰", "🍞", "🥐", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗", "🥩", "🥓", "🍔", "🍟", "🍕", "🌭", "🥪", "🌮", "🌯", "🫔", "🥙", "🧆", "🥚", "🍲", "🫕", "🥗", "🍿", "🧈", "🥫", "🍱", "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣", "🍤", "🍥", "🥮", "🍡", "🥟", "🥠", "🥡", "🦪", "🍦", "🍧", "🍨", "🍩", "🍪", "🍰", "🧁", "🥧", "🍫", "🍬", "🍭", "🍮", "🍯", "🥛", "☕", "🍵", "🧋", "🧃", "🧉", "🧊"
  ].freeze
  
  # 100 emojis you can't eat
  INEDIBLES = [
    "💌", "💣", "🔪", "🏺", "🧭", "🧱", "💈", "🧳", "⏳", "⏰", "🧨", "🎈", "🎉", "🧧", "🎀", "🎁", "🤿", "🪁", "🔮", "🪄", "🧿", "🧸", "🪅", "🪆", "🧵", "🧶", "📿", "💎", "📯", "📻", "🪕", "📱", "📟", "🔋", "💻", "💾", "📀", "🧮", "🎥", "📺", "📷", "📹", "📼", "🔍", "💡", "🔦", "🏮", "🪔", "📔", "📚", "📓", "💰", "💵", "💳", "📦", "📅", "📌", "📎", "🔑", "🔨", "🪓", "🪃", "🪚", "🔧", "🔩", "🔗", "🪝", "🧰", "🧲", "🪜", "🔬", "🔭", "📡", "🩹", "🪑", "🚽", "🪠", "🛁", "🪒", "🧴", "🧹", "🧺", "🧻", "🪣", "🧼", "🪥", "🧽", "🧯", "🗿", "🏀", "🏈", "🛼", "🎮", "🎲", "🚗", "🚀", "🚁", "🛶", "🛸", "🛵"
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
