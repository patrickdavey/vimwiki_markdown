require 'spec_helper'

module VimwikiMarkdown
  describe VimwikiLink do
    let(:markdown_link) { "[title](http://www.google.com)" }
    let(:source_filepath) { "unimportant" }
    let(:markdown_extension) { ".md" }
    let(:root_path) { "-" }

    it "should leave external links alone" do
      link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path)
      expect(link.title).to eq("title")
      expect(link.uri).to eq("http://www.google.com")
    end

    context "with an existing markdown file matching name" do
      let(:existing_file) { "test#{markdown_extension}" }
      let(:existing_file_no_extension) { existing_file.gsub(/#{markdown_extension}$/,"") }
      let(:temp_wiki_dir) { Pathname.new(Dir.mktmpdir("temp_wiki_")) }
      let(:markdown_link) { "[test](#{existing_file})" }
      let(:source_filepath) { temp_wiki_dir + "index.md" }

      before(:each) do
        # here we create a stub test filename in the directory,
        FileUtils.mkdir_p((temp_wiki_dir + existing_file).dirname)
        FileUtils.touch(temp_wiki_dir + existing_file)
      end

      after(:each) do
        FileUtils.rm_r(temp_wiki_dir)
      end

      it "must convert same-directory markdown links correctly" do
        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path)
        expect(link.title).to eq("test")
        expect(link.uri).to eq("#{existing_file_no_extension}.html")
      end

      it "must convert same-directory markdown links with no extension correctly" do
        markdown_link =  "[test](#{existing_file_no_extension})"

        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path)
        expect(link.title).to eq("test")
        expect(link.uri).to eq("#{existing_file_no_extension}.html")
      end

      context "subdirectory linked files" do
        let(:existing_file) { "subdirectory/test.md" }

        it "must convert markdown links correctly" do
          link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path)
          expect(link.title).to eq("test")
          expect(link.uri).to eq("#{existing_file_no_extension}.html")
        end

        it "must convert directory links correctly" do
          markdown_link =  "[subdirectory](subdirectory/)"
          link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path)
          expect(link.title).to eq("subdirectory")
          expect(link.uri).to eq("subdirectory/")
        end

      end

      context "../ style links" do
        let(:existing_file) { "test.md" }
        let(:source_filepath) { temp_wiki_dir + "subdirectory/index.md" }

        it "must convert sub-directory markdown links correctly" do
          link = VimwikiLink.new("[test](../test)", source_filepath, markdown_extension, root_path)
          expect(link.title).to eq("test")
          expect(link.uri).to eq("../test.html")
        end
      end

      context "aboslutely linked files" do
        let(:existing_file) { "test.md" }
        let(:source_filepath) { temp_wiki_dir + "subdirectory/index.md" }
        let(:root_path) { "../"}

        it "must convert absolute paths correctly" do
          link = VimwikiLink.new("[test](/test.md)", source_filepath, markdown_extension, root_path)
          expect(link.uri).to eq("/test.html")
        end

        it "must convert absolute paths without extension correctly" do
          link = VimwikiLink.new("[test](/test)", source_filepath, markdown_extension, root_path)
          expect(link.uri).to eq("/test.html")
        end

        context "from the root directory" do
          let(:source_filepath) { temp_wiki_dir + "index.md" }

          it "must convert absolute paths correctly" do
            link = VimwikiLink.new("[test](/test)", source_filepath, markdown_extension, ".")
            expect(link.uri).to eq("/test.html")
          end
        end
      end
    end
  end
end
