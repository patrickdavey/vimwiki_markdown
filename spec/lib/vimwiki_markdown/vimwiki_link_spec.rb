require "spec_helper"

module VimwikiMarkdown
  describe VimwikiLink do
    let(:markdown_extension) { ".md" }
    let(:root_path) { "-" }

    context "external or fragment only" do
      let(:markdown_link) { "[title](http://www.google.com)" }
      let(:source_filepath) { "unimportant" }
      let(:output_dir) { "unused in this scenario" }

      it "should leave external links alone" do
        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq(markdown_link)
      end

      it "should not alter fragments which are part of a url" do
        markdown_link = "[test](http://foo#Bar)"

        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq("[test](http://foo#Bar)")
      end

      it "should not alter fragment-only links" do
        markdown_link = "[test](#GTD)"

        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq("[test](#GTD)")
      end
    end

    context "with an existing markdown file matching name" do
      let(:existing_file) { "test#{markdown_extension}" }
      let(:existing_file_no_extension) { existing_file.gsub(/#{markdown_extension}$/,"") }
      let(:temp_wiki_dir) { Pathname.new(Dir.mktmpdir("temp_wiki_")) }
      let(:markdown_link) { "[test](#{existing_file})" }
      let(:source_filepath) { temp_wiki_dir + "index.md" }
      let(:output_dir) { temp_wiki_dir + "temp_output_dir" }

      before(:each) do
        # here we create a stub test filename in the directory,
        FileUtils.mkdir_p((temp_wiki_dir + existing_file).dirname)
        FileUtils.mkdir_p(output_dir)
        FileUtils.touch(temp_wiki_dir + existing_file)
      end

      after(:each) do
        FileUtils.rm_r(temp_wiki_dir)
      end

      it "must convert same-directory markdown links correctly" do
        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq("[test](#{existing_file_no_extension}.html)")
      end

      it "must convert same-directory markdown links with no extension correctly" do
        markdown_link = "[test](#{existing_file_no_extension})"

        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq("[test](#{existing_file_no_extension}.html)")
      end

      it "must convert same-directory markdown links with url fragments correctly" do
        markdown_link = "[test](#{existing_file_no_extension}#Wiki Heading)"

        link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
        expect(link.to_s).to eq("[test](#{existing_file_no_extension}.html#wiki-heading)")
      end

      context "subdirectory linked files" do
        let(:existing_file) { "subdirectory/test.md" }

        it "must convert markdown links correctly" do
          link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](#{existing_file_no_extension}.html)")
        end

        it "must convert directory links correctly" do
          markdown_link = "[subdirectory](subdirectory/)"
          link = VimwikiLink.new(markdown_link, source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[subdirectory](subdirectory/)")
        end
      end

      context "../ style links" do
        let(:existing_file) { "test.md" }
        let(:source_filepath) { temp_wiki_dir + "subdirectory/index.md" }

        it "must convert sub-directory markdown links correctly" do
          link = VimwikiLink.new("[test](../test)", source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](../test.html)")
        end
      end

      context "aboslutely linked files" do
        let(:existing_file) { "test.md" }
        let(:source_filepath) { temp_wiki_dir + "subdirectory/index.md" }
        let(:root_path) { "../"}

        it "must convert absolute paths correctly" do
          link = VimwikiLink.new("[test](/test.md)", source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](/test.html)")
        end

        it "must convert absolute paths without extension correctly" do
          link = VimwikiLink.new("[test](/test)", source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](/test.html)")
        end

        context "from the root directory" do
          let(:source_filepath) { temp_wiki_dir + "index.md" }

          it "must convert absolute paths correctly" do
            link = VimwikiLink.new("[test](/test)", source_filepath, markdown_extension, ".", output_dir)
            expect(link.to_s).to eq("[test](/test.html)")
          end
        end
      end

      context "links with local: files" do
        let(:sample_png) { "foo.png" }

        before do
          FileUtils.touch(temp_wiki_dir + sample_png)
        end

        it "must convert local paths correctly" do
          link = VimwikiLink.new("[test](local:#{sample_png})", source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](../#{sample_png})")
        end
      end

      context "links with file: files" do
        let(:sample_png) { "foo.png" }

        before do
          FileUtils.touch(temp_wiki_dir + sample_png)
        end

        it "must convert local paths correctly" do
          link = VimwikiLink.new("[test](file:#{sample_png})", source_filepath, markdown_extension, root_path, output_dir)
          expect(link.to_s).to eq("[test](#{temp_wiki_dir + sample_png})")
        end
      end
    end
  end
end
