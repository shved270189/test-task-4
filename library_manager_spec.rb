require './library/library.rb'

describe Library::Book do
  let(:book1){Library::Book.new "Leo Tolstoy", "War and Peace"}
  let(:book2){Library::Book.new "Oscar Wilde", "The Picture of Dorian Gray"}

  it 'should count comments on all books' do
    book1.add_comment "The first comment"
    book1.add_comment "The second comment"
    book2.add_comment "The comment on second book"
    expect(Library::Book.comments_quantity).to eq 3
  end

  it 'should be commentable' do
    book1.add_comment "The comment"
    expect(book1.comments).to eq ["The comment"]
  end

end

describe Library::Author do
  let!(:author){Library::Author.new "Leo Tolstoy", 0, 0}

  it 'should be commentable' do
    author.add_comment "The comment"
    expect(Library::Author.comments_quantity).to eq 1
    expect(author.comments.count).to eq 1
    expect(author.comments).to eq ["The comment"]
  end

end

describe Library::Manager do

  let(:leo_tolstoy) { Library::Author.new(1828, 1910, 'Leo Tolstoy' ) }
  let!(:oscar_wilde) { Library::Author.new(1854, 1900, 'Oscar Wilde') }
  let!(:war_and_peace) { Library::PublishedBook.new(leo_tolstoy, 'War and Peace', 1400, 3280, 1996) }
  let!(:ivan) {Library::Reader.new('Ivan Testenko', 16)}
  let!(:ivan_testenko) { Library::ReaderWithBook.new(ivan, war_and_peace, 328, (DateTime.now.new_offset(0) + 2.days)) }
  let!(:manager) { Library::Manager.new([],[], [ivan_testenko]) }

  it 'should compose reader notification' do
    expect(manager.reader_notification("Ivan Testenko")). to eq <<-TEXT
Dear Ivan Testenko!

You should return a book "War and Peace" authored by Leo Tolstoy in 48.0 hours.
Otherwise you will be charged $16.44 per hour.
By the way, you are on 328 page now and you need 184.0 hours to finish reading "War and Peace"
TEXT
  end

  it 'should compose librarian notification' do
    expect(manager.librarian_notification). to eq <<-TEXT
Hello,

There are 1 published books in the library.
There are 1 readers and 1 of them are reading the books.

Ivan Testenko is reading "War and Peace" - should return on 2016-04-17 at  2 pm - 184.0 hours of reading is needed to finish.
TEXT
  end
  
end
