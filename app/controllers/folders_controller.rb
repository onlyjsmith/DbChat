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
    
  def makelinkfile
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
    
    # send_data file, :type => 'text/html', :filename => 'link.html'
    # file_download = File.open('tmp/testfile.txt')
    # send_data file #'tmp/testfile.txt'
    session = Dropbox::Session.new('guz0cfjji0pz9pm', 'qfx1avcs77qjbek')
    # debugger
    
    session.authorize
    session.create_folder ('new')
    # session.account
    debugger
    # session.create_folder ('test/wow')
    # uploaded_file = session.file('testfile.txt')
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
