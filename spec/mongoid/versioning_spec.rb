require_relative '../spec_helper'

describe Mongoid::Versioning do
  describe '.max_versions' do
    context 'when provided an integer' do
      before do
        WikiPage.max_versions(10)
      end

      after do
        WikiPage.max_versions(5)
      end

      it 'sets the class version max' do
        expect(WikiPage.version_max).to eq(10)
      end
    end

    context 'when provided a string' do
      before do
        WikiPage.max_versions('10')
      end

      after do
        WikiPage.max_versions(5)
      end

      it 'sets the class version max' do
        expect(WikiPage.version_max).to eq(10)
      end
    end
  end

  describe '#version' do
    context 'when there is no default scope' do
      context 'when the document is new' do
        it 'returns 1' do
          expect(WikiPage.new.version).to eq(1)
        end
      end

      context 'when the document is persisted once' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        it 'returns 1' do
          expect(page.version).to eq(1)
        end
      end

      context 'when the document is persisted more than once' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        before do
          3.times { |n| page.update_attribute(:title, n.to_s) }
        end

        it 'returns the number of versions' do
          expect(page.version).to eq(4)
        end
      end

      context 'when maximum versions is defined' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        context 'when saving over the max versions limit' do
          before do
            10.times { |n| page.update_attribute(:title, n.to_s) }
          end

          it 'returns the number of versions' do
            expect(page.version).to eq(11)
          end
        end
      end

      context 'when performing versionless saves' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        before do
          10.times do |n|
            page.versionless { |doc| doc.update_attribute(:title, n.to_s) }
          end
        end

        it 'does not increment the version number' do
          expect(page.version).to eq(1)
        end
      end
    end

    context 'when there is a default scope' do
      before :all do
        class WikiPage
          default_scope -> { where(author: 'Jim') }
        end
      end

      after :all do
        WikiPage.default_scoping = nil
      end

      context 'when the document is new' do
        it 'returns 1' do
          expect(WikiPage.new.version).to eq(1)
        end
      end

      context 'when the document is persisted once' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        it 'returns 1' do
          expect(page.version).to eq(1)
        end
      end

      context 'when the document is persisted more than once' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        before do
          3.times { |n| page.update_attribute(:title, n.to_s) }
        end

        it 'returns the number of versions' do
          expect(page.version).to eq(4)
        end
      end

      context 'when maximum versions is defined' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        context 'when saving over the max versions limit' do
          before do
            10.times { |n| page.update_attribute(:title, n.to_s) }
          end

          it 'returns the number of versions' do
            expect(page.version).to eq(11)
          end
        end
      end

      context 'when performing versionless saves' do
        let(:page) do
          WikiPage.create(title: '1')
        end

        before do
          10.times do |n|
            page.versionless { |doc| doc.update_attribute(:title, n.to_s) }
          end
        end

        it 'does not increment the version number' do
          expect(page.version).to eq(1)
        end
      end
    end

    context 'when not using the default database' do
      let(:title) { 'my new wiki' }

      let!(:page) do
        WikiPage.new(description: '1', title: title).tap do |page|
          page.with(database: database_id_alt) do |page_alt|
            page_alt.save!
          end
        end
      end

      context 'when the document is persisted once' do
        it 'returns 1' do
          expect(page.version).to eq(1)
        end

        it 'does not persist to default database' do
          expect do
            WikiPage.find_by(title: title)
          end.to raise_error(Mongoid::Errors::DocumentNotFound)
        end

        it 'persists to specified database' do
          expect(WikiPage.with(database: database_id_alt) { |w| w.find_by(title: title) }).not_to be_nil
        end
      end

      context 'when the document is persisted more than once' do
        before do
          skip "Mongoid 6 bug: https://jira.mongodb.org/browse/MONGOID-5379"
          3.times do |n|
            page.with(database: database_id_alt) do |page_alt|
              page_alt.update_attribute(:description, n.to_s)
            end
          end
        end

        it 'returns the number of versions' do
          page.with(database: database_id_alt) do |page_alt|
            expect(page_alt.version).to eq(4)
          end
        end

        it 'persists to specified database' do
          expect(WikiPage.with(database: database_id_alt) { |w| w.find_by(title: title) }).not_to be_nil
        end

        it 'persists the versions to specified database' do
          expect(WikiPage.with(database: database_id_alt).find_by(title: title).version).to eq(4)
        end
      end

      after do
        WikiPage.with(database: database_id_alt) do |wiki_clazz|
          wiki_clazz.delete_all
        end
      end
    end
  end

  describe '#versionless' do
    let(:page) do
      WikiPage.new(created_at: Time.now.utc)
    end

    context 'when executing the block' do
      it 'sets versionless to true' do
        page.versionless do |doc|
          expect(doc.send(:versionless?)).to be_truthy
        end
      end
    end

    context 'when the block finishes' do
      it 'sets versionless to false' do
        page.versionless
        expect(page.send(:versionless?)).to be_falsy
      end
    end
  end

  describe '#versions' do
    let(:page) do
      WikiPage.create(title: '1', description: 'test') do |wiki|
        wiki.author = 'woodchuck'
      end
    end

    context 'when saving the document ' do
      context 'when the document has changed' do
        before do
          page.update_attribute(:title, '2')
        end

        let(:version) do
          page.versions.first
        end

        it 'creates a new version' do
          expect(version.title).to eq('1')
        end

        it 'properly versions the localized fields' do
          expect(version.description).to eq('test')
        end

        it 'only creates 1 new version' do
          expect(page.versions.count).to eq(1)
        end

        it 'does not version the _id' do
          expect(version._id).to be_nil
        end

        it 'does version the updated_at timestamp' do
          expect(version.updated_at).not_to be_nil
        end

        context 'when only updated_at was changed' do
          before do
            page.update_attributes(updated_at: Time.now)
          end

          it 'does not generate another version' do
            expect(page.versions.count).to eq(1)
          end
        end

        it 'does not embed versions within versions' do
          expect(version.versions).to be_empty
        end

        it 'versions protected fields' do
          expect(version.author).to eq('woodchuck')
        end

        context 'when saving multiple times' do
          before do
            page.update_attribute(:title, '3')
          end

          it 'does not embed versions within versions' do
            expect(version.versions).to be_empty
          end

          it 'does not embed versions multiple levels deep' do
            expect(page.versions.last.versions).to be_empty
          end
        end
      end

      context 'when the document has not changed' do
        before do
          page.save
        end

        let(:version) do
          page.versions.first
        end

        it 'does not create a new version' do
          expect(version).to be_nil
        end
      end

      context 'when saving over the number of maximum versions' do
        context 'when saving in succession' do
          before do
            10.times do |n|
              page.update_attribute(:title, n.to_s)
            end
          end

          it 'only versions the maximum amount' do
            expect(page.reload.versions.count).to eq(5)
          end

          it 'shifts the versions in order' do
            expect(page.reload.versions.last.title).to eq('8')
          end

          it 'persists the version shifts' do
            expect(page.reload.versions.last.title).to eq('8')
            expect(page.reload.versions.first.title).to eq('4')
          end
        end

        context 'when saving in batches' do
          before do
            2.times do
              5.times do |n|
                WikiPage.find(page.id).update_attributes(title: n.to_s)
              end
            end
          end

          let(:from_db) do
            WikiPage.find(page.id)
          end

          let(:versions) do
            from_db.versions
          end

          it 'only versions the maximum amount' do
            expect(versions.count).to eq(5)
          end
        end
      end

      context 'when persisting versionless' do
        before do
          page.versionless { |doc| doc.update_attribute(:title, '2') }
        end

        it 'does not version the document' do
          expect(page.versions.count).to eq(0)
        end
      end

      context 'when deleting versions' do
        let(:comment) do
          Comment.new(title: "Don't delete me!")
        end

        before do
          page.comments << comment
          page.update_attribute(:title, '5')
        end

        context 'when the version had a dependent relation' do
          before do
            page.versions.delete_all
          end

          let(:from_db) do
            Comment.find(comment.id)
          end

          it 'does not perform dependent cascading' do
            expect(from_db).to eq(comment)
          end

          it 'deletes the version' do
            expect(page.versions).to be_empty
          end

          it 'persists the deletion' do
            expect(page.reload.versions).to be_empty
          end

          it 'retains the root relation' do
            expect(page.reload.comments).to eq([comment])
          end
        end
      end
    end
  end

  context 'when appending a self referencing document with versions' do
    let(:page) do
      WikiPage.create(title: '1')
    end

    let(:child) do
      WikiPage.new
    end

    before do
      page.child_pages << child
    end

    it 'allows the document to be added' do
      expect(page.child_pages).to eq([child])
    end

    it 'persists the changes' do
      expect(page.reload.child_pages).to eq([child])
    end
  end
end
