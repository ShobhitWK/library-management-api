class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email,subject:"[Library Management API] Somebody just signed into your account.")
  end

  def new_registration(user,password)
    @user = user
    @password = password
    mail(to: @user.email,subject:"Welcome to Library Management API")
  end

  def new_book_creation(book)
    @book = book
    mail(to: @book.user.email,subject:"[#{@book.name}] Book | Successfully Created!")
  end

  def issue_request_create(book)
    @issuedbook = book
    mail(to: @issuedbook.user.email,subject:"Book Issued Successfully: #{@issuedbook.book.name}")
  end

  def issue_return_create(book)
    @issuedbook = book
    mail(to: @issuedbook.user.email,subject:"Book Returned Successfully: #{@issuedbook.book.name}")
  end

end
