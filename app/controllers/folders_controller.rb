class FoldersController < ApplicationController
  # GET /folders
  # GET /folders.xml
  def index
    @folders = Folder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @folders }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    @folder = Folder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    @folder = Folder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @folder = Folder.find(params[:id])
  end

  # POST /folders
  # POST /folders.xml
  def create
    @folder = Folder.new(params[:folder])

    respond_to do |format|
      if @folder.save
        format.html { redirect_to(@folder, :notice => 'Folder was successfully created.') }
        format.xml  { render :xml => @folder, :status => :created, :location => @folder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.xml
  def update
    @folder = Folder.find(params[:id])

    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.html { redirect_to(@folder, :notice => 'Folder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.xml
  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy

    respond_to do |format|
      format.html { redirect_to(folders_url) }
      format.xml  { head :ok }
    end
  end

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


  # This was copied from Dropbox gem - no idea if it should go in here. Seems like it needs a session already set up
   def authorize
     if params[:oauth_token] then
       dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
       dropbox_session.authorize(params)
       session[:dropbox_session] = dropbox_session.serialize # re-serialize the authenticated session
  
       redirect_to :action => 'makelinkfile'
     else
       dropbox_session = Dropbox::Session.new('6ov6muazu1umw24', 'yzhax5he3o5t4ci')
       session[:dropbox_session] = dropbox_session.serialize
       redirect_to dropbox_session.authorize_url(:oauth_callback => root_url)
     end
   end
  
    
  def makelinkfile
    folder = params[:folder]
    file =
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
        <html>
        <head>
        <title>Redirection coming up...</title>
        <meta http-equiv="REFRESH" content="0;url=http://localhost:3000/folders/'+folder.to_s+'"></HEAD>
        <BODY>
        Redirecting to your desired page.
        </BODY>
        </HTML>'
    
    # send_data file, :type => 'text/html', :filename => 'link.html'
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    dropbox_session.authorize
    dropbox_session.mode = :dropbox
    
    file = File.open("lib/testfile.txt")
    dropbox_session.upload(file, "test/")
    
    @account = dropbox_session.account
  end
  
  def upload
    return redirect_to(:action => 'authorize') unless session[:dropbox_session]
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    return redirect_to(:action => 'authorize') unless dropbox_session.authorized?

    if request.method == :post then
      dropbox_session.upload params[:file], 'My Uploads'
      render :text => 'Uploaded OK'
    else
      # display a multipart file field form
    end
  end  
    
end
