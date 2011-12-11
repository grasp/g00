class MailAccountsController < ApplicationController
  # GET /mail_accounts
  # GET /mail_accounts.xml
    layout "admin"
    include MailAccountsHelper
  def index
    batch_insert_gmail_account
    batch_insert_netease_account
    batch_insert_hotmail_account
    @mail_accounts = MailAccount.all.desc(:fail_counter)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mail_accounts }
    end
  end

  def tuiguang
    Rails.logger.info "domain=#{params[:domain]}"
    mode=params[:mode] ||"test"
    domain=params[:domain].gsub!(/#/,".").to_s ||"smtp.gmail.com"
    sent_tuiguang_email(mode,domain)
  end

  def receive
     mode=params[:mode] ||"test"
    domain=params[:domain].gsub!(/#/,".").to_s ||"smtp.gmail.com"
    receive_helper(mode,domain)
  end

  # GET /mail_accounts/1
  # GET /mail_accounts/1.xml
  def show
    @mail_account = MailAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mail_account }
    end
  end

  # GET /mail_accounts/new
  # GET /mail_accounts/new.xml
  def new
    @mail_account = MailAccount.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mail_account }
    end
  end

  # GET /mail_accounts/1/edit
  def edit
    @mail_account = MailAccount.find(params[:id])
  end

  # POST /mail_accounts
  # POST /mail_accounts.xml
  def create
    @mail_account = MailAccount.new(params[:mail_account])

    respond_to do |format|
      if @mail_account.save
        format.html { redirect_to(@mail_account, :notice => 'Mail account was successfully created.') }
        format.xml  { render :xml => @mail_account, :status => :created, :location => @mail_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mail_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mail_accounts/1
  # PUT /mail_accounts/1.xml
  def update
    @mail_account = MailAccount.find(params[:id])
    respond_to do |format|
      if @mail_account.update_attributes(params[:mail_account])
        format.html { redirect_to(@mail_account, :notice => 'Mail account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mail_accounts/1
  # DELETE /mail_accounts/1.xml
  def destroy
    @mail_account = MailAccount.find(params[:id])
    @mail_account.destroy

    respond_to do |format|
      format.html { redirect_to(mail_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
