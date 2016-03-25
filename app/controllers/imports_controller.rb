class ImportsController  < ApplicationController
  
  before_filter :authenticate_agent!
  
  def create
    @import = Import.new(import_params)
    @import.agent = current_agent
    if @import.save

      n = File.open("/tmp/" + @import.csvfile_file_name, "w") {|f| 
          f.write(File.open(@import.csvfile.path, "r:ISO-8859-1").read.encode(:universal_newline => true))
      }
      system("/bin/mv " + " /tmp/" + @import.csvfile_file_name + " " +  @import.csvfile.path)
      File.open(@import.csvfile.path, "r").readlines.each do |line|
        @import.importbacklogs << Importbacklog.create(csvline: line)
      end
      redirect_to '/imports'
    end
  end
  
  def destroy
    @import = Import.find(params[:id])
    if @import.agent == current_agent
      @import.destroy!
    else
      flash[:error] = 'This is not your file to delete.'
    end
    redirect_to '/imports'
  end
  
  
  def index
    @imports = Import.by_agent(current_agent.id)
    set_meta_tags title: 'Import old spreadsheets'
  end
  
  def pbtprocess
    @import = Import.find(params[:id])

  end
  
  def process_columns
    @import = Import.find(params[:id])
    if @import.agent != current_agent
      flash[:error] = 'This is not your file to delete.'
    else
      columns = params[:column].sort.map(&:last)
      @import.importbacklogs.each do |line|
        newentry = @import.category.constantize.new
        
        CSV.parse(line.csvline).each do |csv|
          csv.each_with_index do |c, index|
            next if columns[index] == 'nil'
            newentry[columns[index]]  = c
            if columns[index] == 'cost'
              if c =~ /£/
                newentry.currency = Currency.find_by(code: 'GBP')
              elsif c =~ /€/
                newentry.currency = Currency.find_by(code: 'EUR')
              else
                begin
                  newentry.currency_id = Currency.find_by(code: Monetize.parse(c.encode("cp1252").force_encoding("UTF-8")).currency.iso_code)
                rescue
                  newentry.currency_id = 1
                end
              end
              newentry[columns[index]]  = Monetize.parse(c.encode("cp1252").force_encoding("UTF-8")).to_f
            end
          end
        end
        newentry.agent_id = current_agent.id
        if newentry.save!
          line.imported = true
          line.pbtentry = newentry
          line.save!
        end
      end
      if @import.importbacklogs.where(imported: false).empty?
        @import.processed = true
        @import.save!
      end
    end
  end
  
  protected
  
  def import_params
    params.require(:import).permit([:year, :category, :csvfile])
  end
  
end