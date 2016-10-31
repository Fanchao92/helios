class Spreadsheet < ActiveRecord::Base
    mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
    validates :name, presence: true # Make sure the owner's name is present.
    validate :is_csv_file
    
    def is_csv_file
        errors.add(:file_extension, " should be .csv, Upload Failed!") unless File.extname(self.attachment.to_s)=='.csv'
    end
    
    def saveAndMove
        
        saved = self.save
        
        # The uploaded file is initially stored in a folder within "attachment" folder. So, 
        # we first need to move the file outside its original folder.
        system('find public/uploads/spreadsheet/attachment/ -type d > Folders.txt')
        line_num=1
        text=File.open('Folders.txt').read
        text.gsub!(/\r\n?/, "\n")
        text.each_line do |line|
            #Move the .csv file into "attachment" folder and delete the original folder
            if line_num > 1 
                line = line.gsub(/\n/,"")
                if saved
                    system('mv ' + line +'/* public/uploads/spreadsheet/attachment/')
                end
                system('rm ' + line +'/ -r')
            end
            line_num += 1
        end 
        
        return saved
        
    end
end
