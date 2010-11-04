class DropboxController < ApplicationController
  def makelink
    @folder = params[:folder]
    file =
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
    <html>
    <head>
    <title>Redirection coming up...</title>
    <meta http-equiv="REFRESH" content="0;url=http://localhost:3000/folders/'+@folder.to_s+'"></HEAD>
    <BODY>
    Redirecting to your desired page.
    </BODY>
    </HTML>'
    send_data file, :type => 'text/html', :filename => 'link.html'
    # redirect_to :back and return
  end

  def authorize
   if params[:oauth_token] then
     dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
     dropbox_session.authorize(params)
     session[:dropbox_session] = dropbox_session.serialize # re-serialize the authenticated session

     redirect_to :action => 'makelinkfile'
   else
     dropbox_session = Dropbox::Session.new('6ov6muazu1umw24', 'yzhax5he3o5t4ci')
     session[:dropbox_session] = dropbox_session.serialize

     # ORIGINAL: 
     # debugger
     # redirect_to dropbox_session.authorize_url(:oauth_callback => root_url)
     redirect_to dropbox_session.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
     # redirect_to dropbox_session.authorize_url(:oauth_callback => 'http://www.google.com')
   end
  end

  def makelinkfile
    folder = params[:folder]
    filecontent =
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
        <html>
        <head>
        <title>Redirection coming up...</title>
        <meta http-equiv="REFRESH" content="0;url=http://localhost:3000/folders/'+folder.to_s+'"></HEAD>
        <BODY>
        Redirecting to your desired page.
        </BODY>
        </HTML>'
  
    # # TODO: Sort this out! At the moment it still requires user to click "authorize" link, then close that window and then click the action they want. This SUCKS!
    #  dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    #  dropbox_session.authorize
    #  dropbox_session.mode = :dropbox

    # Copied this from https://github.com/RISCfuture/dropbox
    return redirect_to(:action => 'authorize') unless session[:dropbox_session]
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    return redirect_to(:action => 'authorize') unless dropbox_session.authorized?
    debugger
    
    # TODO: Make the dynamic file in a smarter way - this way will cause problems if more than 1 person using it...
    File.open("tmp/DropboxChat.html", 'w') do |f|
      f.puts(filecontent)
    end
    dropbox_session.mode = :dropbox
    dropbox_session.upload("tmp/DropboxChat.html", "test/")
    # File.delete("tmp/DropboxChat.html")
    @account = dropbox_session.account
  end

  def listfolders
    # TODO: Expecting this to have the same need for clicking the authorize link before this will work...
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    dropbox_session.authorize
    dropbox_session.mode = :dropbox
    @list = dropbox_session.list '/'
    debugger
    puts @list
  end
end