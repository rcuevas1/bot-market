class BotMessageDispatcher
  attr_reader :message, :user

  def initialize(message, user)
    @message = message
    @user = user
  end

  #process the message that arrived
  def process

    #see if it is a command text first
    if message[:message][:entities] != nil
      if message[:message][:entities][0][:type] == "bot_command"
        text = message[:message][:text]
        if text.start_with?('/rut')
          require 'chilean_rut'
          text.slice!('/rut')
          text.gsub(/\s+/, "")
          text.insert(text.length-1,"-")
          rut = text.strip
          if RUT::validate(rut)
            #next message and save rut
            user.user_info = user.user_info.merge(rut: rut)
            user.save
            command = BotCommand::GoodRut.new(user, message)
            command.start
          else
            #not valid rut message
            command = BotCommand::BadRut.new(user, message)
            command.start
          end
        elsif text.start_with?('/cuenta')
          command = BotCommand::GetDebt.new(user, message)
          command.start
        elsif text.start_with?('/email')
          user.user_info = user.user_info.merge(email_text: text)
          user.save
          command = BotCommand::SomeMessage.new(user, "Listo, guardé tu correo, te avisaré cuando esté listo.")
          command.start
        end
      end
    else
      min_attributes = false
      if user.user_info["rut"] != nil
        min_attributes = true
      end
      #if not min_attributes ask user for rut and phone
      if !min_attributes
        start_command = BotCommand::Start.new(user, message)
        start_command.start
      else
        command = BotCommand::GetDebt.new(user, message)
        command.start
      end
      #if user has all his minimum attributes (rut and phone) it should pass to process message
  
    end

    
    

    # if user.get_next_bot_command
    #   bot_command = user.get_next_bot_command.safe_constantize.new(user, message)

    #   if bot_command.should_start?
    #     bot_command.start
    #   else
    #     unknown_command
    #   end
    # else
    #   start_command = BotCommand::Start.new(user, message)

    #   if start_command.should_start?
    #     start_command.start
    #   else
    #     unknown_command
    #   end
    # end
  end
  
  private

  def unknown_command
    BotCommand::Undefined.new(user, message).start
  end
end