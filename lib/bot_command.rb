require 'telegram/bot' #gem

module BotCommand
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      @user = user
      @message = message
      token = Rails.application.secrets.bot_token
      @api = ::Telegram::Bot::Api.new(token)
    end

    def should_start?
      raise NotImplementedError
    end

    def start
      raise NotImplementedError
    end

    protected

    def send_message(text, options={})
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text)
    end

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from]
    end
  end

  class Born < Base
    def should_start?
      text =~ /\A\/born/
    end

    def start
      send_message("You have been just born! It’s time to learn some programming stuff. Type /accomplish_tutorial to start learning Rails from simple tutorial!")
      user.set_next_bot_command('BotCommand::AccomplishTutorial')
    end
  end

  class Start < Base
    def should_start?
      text =~ /\A\/start/
    end

    def start
      send_message('Bienvenido, para darte información sobre tus cuentas debes darme tu RUT sin puntos ni guión.\n De esta forma: rut/ 123456789')
      user.reset_next_bot_command
      user.set_next_bot_command('BotCommand::Born')
    end
  end

  class AccomplishTutorial < Base
    def should_start?
      text =~ /\A\/accomplish_tutorial/
    end

    def start
      send_message("It was hard, but it’s over! Models, controllers, views, wow, a lot stuff! Let’s practice now. What do you think about writing a Rails blog? Type /write_blog to continue.")
      user.set_next_bot_command('BotCommand::WriteBlog')
    end
  end

  class WriteBlog < Base
    def should_start?
      text =~ /\A\/write_blog/
    end

    def start
      send_message('Hmm, looks cool! Seems like you really know Rails! A real rockstar!')
      user.reset_next_bot_command
    end
  end
  
  class Undefined < Base
    def start
      send_message('Unknown command. Type /start if you are a new user or you have finished the game, else type the appropriate command.')
    end
  end

end