# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170120030446) do

  create_table "activities", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address"
    t.string   "company"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "agents", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "surname",                limit: 25
    t.integer  "age"
    t.integer  "agent_since"
    t.string   "location",               limit: 25
    t.text     "missionname",            limit: 65535
    t.string   "encrypted_password",     limit: 128,   default: "",                         null: false
    t.datetime "lastlogin",                            default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "role",                   limit: 12
    t.string   "username",               limit: 24
    t.string   "imageurl"
    t.boolean  "active",                               default: false
    t.datetime "created_at"
    t.string   "headingsize",            limit: 5,     default: "0.9em"
    t.string   "rowsize",                limit: 5,     default: "0.8em"
    t.string   "defaultsort",            limit: 4,     default: "DESC",                     null: false
    t.text     "css",                    limit: 65535
    t.string   "oddrowcolor",            limit: 7,     default: "#c0c0c0"
    t.string   "evenrowcolor",           limit: 7,     default: "#909090"
    t.string   "headingcolor",           limit: 7,     default: "#000000"
    t.string   "bghighlightcolor",       limit: 7,     default: "#00007f"
    t.string   "fghighlightcolor",       limit: 7,     default: "#ffffff"
    t.string   "textcolor",              limit: 7,     default: "#000000"
    t.text     "freetext",               limit: 65535
    t.string   "public_password",        limit: 36
    t.string   "defaultcurrency",        limit: 7,     default: "$"
    t.float    "ratingscale",            limit: 24,    default: 10.0
    t.string   "dateformat",             limit: 16,    default: "Y-m-d"
    t.datetime "updated_at"
    t.string   "email",                  limit: 80
    t.string   "lastfm",                 limit: 24
    t.integer  "theme_id",                             default: 1
    t.string   "twitname",               limit: 48
    t.string   "twitpasswd",             limit: 48
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.boolean  "email_notify",                         default: false,                      null: false
    t.integer  "security",                             default: 0,                          null: false
    t.string   "password_salt",                        default: "",                         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "slug"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.binary   "discogs_token",          limit: 65535
  end

  create_table "airports", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id",                     null: false
    t.date     "date"
    t.string   "name"
    t.string   "code",           limit: 3
    t.string   "destination"
    t.integer  "time_spent"
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "bars", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                         null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "company"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "books", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_book_id"
    t.integer  "agent_id"
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.string   "difficulty",     limit: 25
    t.integer  "pagecount"
    t.string   "source"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.integer  "label_id"
    t.text     "comment",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "first",                        default: true
    t.integer  "currency_id"
    t.boolean  "delta"
    t.string   "userimage"
    t.boolean  "abandoned"
    t.date     "abandoned_at"
    t.index ["agent_id"], name: "books_agent_idx", using: :btree
    t.index ["agent_id"], name: "books_agents_idx", using: :btree
  end

  create_table "brewing", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "product"
    t.string   "task"
    t.string   "company"
    t.string   "location"
    t.float    "cost",           limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage"
    t.boolean  "delta"
    t.integer  "currency_id"
    t.integer  "agent_id"
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geolocation_id"
    t.string   "venue_address"
  end

  create_table "categories", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer "agent_id"
    t.integer "year"
    t.string  "movies",      limit: 50, default: "Movies"
    t.string  "musics",      limit: 50, default: "Music"
    t.string  "books",       limit: 50, default: "Books"
    t.string  "restaurants", limit: 50, default: "Restaurants"
    t.string  "bars",        limit: 50, default: "Bars"
    t.string  "takeaway",    limit: 50, default: "Takeaway"
    t.string  "concerts",    limit: 50, default: "Concerts"
    t.string  "events",      limit: 50, default: "Events"
    t.string  "eating",      limit: 50, default: "Eating"
    t.string  "exercise",    limit: 50, default: "Exercise"
    t.string  "weight",      limit: 50, default: "Weight"
    t.string  "musicplayed", limit: 50, default: "Music Played"
    t.string  "activities",  limit: 50, default: "Activities"
    t.string  "gambling",    limit: 50, default: "Gambling"
    t.string  "miles",       limit: 50, default: "Mileage"
    t.string  "loans",       limit: 50, default: "Loans"
    t.string  "airports",    limit: 50, default: "Airports"
    t.string  "projects",    limit: 50, default: "Projects"
    t.string  "videogames",  limit: 50, default: "Video Games"
    t.string  "brewing",     limit: 50, default: "Brewing"
    t.string  "tasks",       limit: 50, default: "Tasks"
    t.string  "groceries",   limit: 50, default: "Groceries"
    t.string  "tvseries",               default: "TV Series"
  end

  create_table "comments", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "item_type",  limit: 48
    t.integer  "foreign_id",               null: false, unsigned: true
    t.text     "content",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id"
    t.boolean  "delta"
  end

  create_table "concerts", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                         null: false
    t.text     "artists",        limit: 65535
    t.string   "venue",          limit: 64
    t.string   "venue_address"
    t.float    "cost",           limit: 24
    t.string   "company"
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
    t.index ["agent_id"], name: "concerts_agent_idx", using: :btree
    t.index ["agent_id"], name: "concerts_agents_idx", using: :btree
  end

  create_table "currencies", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "name",      limit: 32
    t.string   "code",      limit: 3
    t.string   "symbol",    limit: 12
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "unitafter",            default: false, null: false
  end

  create_table "eating", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "drink",          limit: 65535
    t.float    "drinkamt",       limit: 24
    t.text     "grain",          limit: 65535
    t.float    "grainamt",       limit: 24
    t.text     "dairy",          limit: 65535
    t.float    "dairyamt",       limit: 24
    t.text     "meat",           limit: 65535
    t.float    "meatamt",        limit: 24
    t.text     "fruitveg",       limit: 65535
    t.float    "fruitvegamt",    limit: 24
    t.text     "sweets",         limit: 65535
    t.float    "sweetsamt",      limit: 24
    t.text     "supplements",    limit: 65535
    t.float    "supplementsamt", limit: 24
    t.integer  "supplementsnum"
    t.integer  "label_id"
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.boolean  "delta"
  end

  create_table "entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.integer  "entry_id"
    t.string   "entry_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                                     null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address"
    t.string   "company"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",                     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
    t.index ["agent_id"], name: "events_agent_idx", using: :btree
  end

  create_table "exchanges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "basecurrency_id"
    t.integer  "othercurrency_id"
    t.boolean  "entire_year"
    t.date     "sample_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rate",             limit: 53
  end

  create_table "exercise", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.text     "activity",   limit: 65535
    t.float    "hours",      limit: 24
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "distance",   limit: 24
    t.integer  "sets"
    t.integer  "reps"
    t.text     "comment",    limit: 65535
    t.string   "userimage",  limit: 80
    t.boolean  "delta"
  end

  create_table "favoritemovies", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.integer  "master_movie_id"
    t.float    "ranking",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.string   "subject"
    t.text     "body",       limit: 65535
    t.datetime "created_at",               default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "delta"
    t.string   "slug"
  end

  create_table "gambling", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                         null: false
    t.string   "name"
    t.string   "location"
    t.text     "games",          limit: 65535
    t.float    "profit",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.float    "rating",         limit: 24
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "geolocation_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "geolocation_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["item_id", "item_type"], name: "index_geolocation_items_on_item_id_and_item_type", using: :btree
  end

  create_table "geolocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "address"
    t.float    "latitude",   limit: 53
    t.float    "longitude",  limit: 53
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groceries", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "name"
    t.string   "location"
    t.float    "cost",           limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage"
    t.boolean  "delta"
    t.integer  "currency_id"
    t.integer  "agent_id"
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "coupons",        limit: 24
    t.float    "clubsavings",    limit: 24
    t.integer  "geolocation_id"
  end

  create_table "import_books", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_book_id"
    t.integer  "agent_id"
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.text     "author",         limit: 65535
    t.text     "title",          limit: 65535
    t.text     "source",         limit: 65535
    t.string   "currency",       limit: 8
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.boolean  "first"
    t.text     "comments",       limit: 65535
    t.datetime "created",                      default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "difficulty",     limit: 25
    t.integer  "pagecount"
  end

  create_table "import_movies", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_movie_id"
    t.integer  "agent_id"
    t.text     "title",           limit: 65535
    t.date     "date"
    t.string   "location",        limit: 64
    t.string   "format",          limit: 15
    t.text     "company",         limit: 65535
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.integer  "label_id"
    t.text     "comment",         limit: 65535
    t.datetime "created",                       default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.date     "started"
  end

  create_table "import_musics", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_music_id"
    t.integer  "agent_id"
    t.date     "date"
    t.text     "artist",          limit: 65535
    t.text     "title",           limit: 65535
    t.text     "label",           limit: 65535
    t.string   "format"
    t.string   "source",          limit: 32
    t.string   "currency",        limit: 8
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.text     "comments",        limit: 65535
    t.datetime "created",                       default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "import_restaurants", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.text     "name",     limit: 65535
    t.text     "location", limit: 65535
    t.text     "company",  limit: 65535
    t.text     "ordered",  limit: 65535
    t.string   "currency", limit: 8
    t.float    "cost",     limit: 24
    t.float    "rating",   limit: 24
    t.text     "comments", limit: 65535
    t.string   "cuisine",  limit: 48
    t.datetime "created",                default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "importbacklogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "import_id"
    t.text     "csvline",       limit: 65535,                 null: false, collation: "utf8_general_ci"
    t.boolean  "imported",                    default: false, null: false
    t.integer  "pbtentry_id"
    t.string   "pbtentry_type"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["import_id"], name: "index_importbacklogs_on_import_id", using: :btree
  end

  create_table "imports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "agent_id"
    t.string   "year"
    t.string   "category"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "csvfile_file_name"
    t.string   "csvfile_content_type"
    t.integer  "csvfile_file_size"
    t.datetime "csvfile_updated_at"
    t.boolean  "processed",            default: false, null: false
    t.index ["agent_id"], name: "index_imports_on_agent_id", using: :btree
  end

  create_table "labels", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.string   "name",       limit: 128
    t.text     "comment",    limit: 65535
    t.string   "bgcolor",    limit: 7
    t.string   "textcolor",  limit: 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id",                                 null: false
    t.date     "date"
    t.date     "ended"
    t.boolean  "is_out",                    default: true, null: false
    t.string   "name",                                     null: false
    t.string   "material",    limit: 80
    t.string   "other_party", limit: 80,                   null: false
    t.text     "comment",     limit: 65535
    t.integer  "label_id"
    t.string   "userimage",   limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta"
  end

  create_table "master_books", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "amazoncode"
    t.text     "author",                limit: 65535
    t.text     "title",                 limit: 65535
    t.integer  "uses",                                default: 0
    t.datetime "created_at",                          default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "filename_file_name"
    t.integer  "filename_file_size"
    t.string   "filename_content_type"
    t.integer  "height"
    t.integer  "width"
    t.datetime "filename_updated_at"
  end

  create_table "master_movies", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "imdbcode"
    t.text     "title",                 limit: 65535
    t.text     "director",              limit: 65535
    t.integer  "year"
    t.text     "country",               limit: 65535
    t.integer  "uses",                                default: 0
    t.datetime "created_at"
    t.string   "filename_file_name"
    t.integer  "filename_file_size"
    t.string   "filename_content_type"
    t.integer  "height"
    t.integer  "width"
    t.datetime "filename_updated_at"
    t.boolean  "delta"
    t.string   "english_title"
    t.boolean  "audited",                             default: false, null: false
  end

  create_table "master_musics", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "discogscode"
    t.text     "artist",                limit: 65535
    t.text     "title",                 limit: 65535
    t.integer  "year"
    t.string   "label"
    t.string   "format",                limit: 64
    t.integer  "uses",                                default: 0
    t.datetime "created",                             default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "filename_file_name"
    t.integer  "filename_file_size"
    t.string   "filename_content_type"
    t.integer  "height"
    t.integer  "width"
    t.datetime "filename_updated_at"
    t.integer  "masterdiscogs_id"
    t.boolean  "converted",                           default: false,                      null: false
  end

  create_table "master_tvseries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.integer  "year"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.integer  "height"
    t.integer  "width"
    t.datetime "image_updated_at"
    t.boolean  "delta"
    t.string   "slug"
    t.integer  "imdbcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "master_videogames", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "amazoncode"
    t.string   "title"
    t.string   "creator"
    t.string   "platform"
    t.string   "filename_file_name"
    t.integer  "filename_file_size"
    t.string   "filename_content_type"
    t.integer  "height"
    t.integer  "width"
    t.datetime "filename_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miles", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "station",     limit: 50
    t.string   "location",    limit: 100
    t.float    "cost",        limit: 24
    t.float    "gasamount",   limit: 24
    t.float    "ppg",         limit: 24
    t.float    "miles",       limit: 24
    t.integer  "label_id"
    t.integer  "currency_id"
    t.text     "comment",     limit: 65535
    t.string   "userimage",   limit: 80
    t.boolean  "delta"
  end

  create_table "movies", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_movie_id"
    t.integer  "agent_id"
    t.date     "started"
    t.date     "date"
    t.string   "location",        limit: 64
    t.string   "venue_address"
    t.string   "format",          limit: 150
    t.string   "company"
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.integer  "label_id"
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.boolean  "is_short",                      default: false
    t.datetime "updated_at"
    t.boolean  "first",                         default: true
    t.integer  "currency_id"
    t.boolean  "delta"
    t.string   "userimage"
    t.integer  "geolocation_id"
    t.index ["agent_id"], name: "movie_agent_idx", using: :btree
  end

  create_table "musicplayed", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.text     "company",        limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address"
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "musics", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_music_id"
    t.integer  "agent_id"
    t.date     "date"
    t.datetime "created_at"
    t.float    "cost",            limit: 24
    t.string   "source"
    t.float    "rating",          limit: 24
    t.integer  "label_id"
    t.text     "comment",         limit: 65535
    t.date     "received"
    t.string   "procurement",                   default: "0"
    t.datetime "updated_at"
    t.boolean  "isnew"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.string   "userimage"
    t.index ["agent_id"], name: "musics_agent_idx", using: :btree
  end

  create_table "newsfeed", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id",              null: false
    t.integer  "foreign_id",            null: false
    t.string   "category",   limit: 40
    t.string   "action",     limit: 10
    t.datetime "time"
  end

  create_table "posts", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id",                                                    null: false
    t.text     "post",     limit: 65535
    t.datetime "created",                default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string   "subject",  limit: 64
  end

  create_table "profiles", primary_key: ["id", "agent_id", "year"], force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "id",                                                     null: false
    t.integer  "agent_id",                                               null: false
    t.integer  "year",                                                   null: false
    t.string   "surname",             limit: 50,                         null: false
    t.integer  "age"
    t.string   "location",            limit: 50
    t.string   "missionname",                                            null: false
    t.string   "imageurl"
    t.boolean  "active",                            default: false,      null: false
    t.integer  "defaultcurrency_id",                default: 1,          null: false
    t.string   "dateformat",          limit: 16,    default: "%Y-%m-%d", null: false
    t.integer  "theme_id",                          default: 1,          null: false
    t.text     "freetext",            limit: 65535
    t.string   "ratingscale",         limit: 25
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "customrss",           limit: 65535
    t.boolean  "showtwitter",                       default: true,       null: false
    t.string   "delicious",           limit: 40
    t.string   "deliciouspw",         limit: 40
    t.string   "avatar_file_name"
    t.integer  "avatar_file_size"
    t.string   "avatar_content_type"
    t.datetime "avatar_updated_at"
    t.text     "theme_settings",      limit: 65535
    t.boolean  "shortfilms"
    t.index ["year", "agent_id"], name: "year", unique: true, using: :btree
  end

  create_table "profiles_themes", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "profile_id",               null: false
    t.integer  "theme_id",                 null: false
    t.text     "settings",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id",                                    null: false
    t.date     "date"
    t.date     "ended"
    t.string   "name"
    t.string   "format"
    t.string   "materials"
    t.string   "tools"
    t.string   "collaborators"
    t.text     "comment",       limit: 65535
    t.string   "userimage",     limit: 80
    t.integer  "label_id"
    t.boolean  "priv",                        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta"
  end

  create_table "references", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.text     "comment",        limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["reference_type", "reference_id"], name: "index_references_on_reference_type_and_reference_id", using: :btree
    t.index ["source_type", "source_id"], name: "index_references_on_source_type_and_source_id", using: :btree
  end

  create_table "restaurants", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                         null: false
    t.string   "name",           limit: 128
    t.string   "location",       limit: 64
    t.string   "company"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.string   "cuisine",        limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
    t.index ["agent_id"], name: "restaurants_agents_idx", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "session_id",               null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "takeaway", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date",                         null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "company"
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.integer  "geolocation_id"
  end

  create_table "themes", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        limit: 24
    t.text     "description", limit: 65535
    t.boolean  "active",                    default: false
    t.datetime "created"
    t.datetime "modified"
    t.text     "defaultcss",  limit: 65535
  end

  create_table "tvseries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.integer  "master_tvseries_id"
    t.date     "started"
    t.date     "finished"
    t.integer  "season"
    t.float    "rating",             limit: 24
    t.text     "comment",            limit: 16777215
    t.boolean  "first"
    t.string   "userimage"
    t.string   "location"
    t.string   "venue_address"
    t.integer  "geolocation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta"
    t.index ["agent_id"], name: "index_tvseries_on_agent_id", using: :btree
    t.index ["geolocation_id"], name: "index_tvseries_on_geolocation_id", using: :btree
    t.index ["master_tvseries_id"], name: "index_tvseries_on_master_tvseries_id", using: :btree
  end

  create_table "userimages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "entry_id"
    t.string   "entry_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_remote_url"
  end

  create_table "videogames", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "master_videogame_id",               null: false
    t.integer  "agent_id"
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.string   "difficulty"
    t.string   "source"
    t.float    "cost",                limit: 24
    t.float    "rating",              limit: 24
    t.integer  "label_id"
    t.text     "comment",             limit: 65535
    t.boolean  "first"
    t.integer  "currency_id"
    t.boolean  "delta"
    t.string   "userimage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "soldprice",           limit: 24
  end

  create_table "views", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer "agent_id"
    t.integer "year",                                                          null: false
    t.string  "movie_started",         limit: 50, default: "Started"
    t.string  "movie_format",          limit: 50, default: "Format"
    t.string  "movie_location",                   default: "Location",         null: false
    t.string  "movie_company",         limit: 50, default: "Company"
    t.string  "movie_cost",            limit: 50, default: "Cost"
    t.string  "movie_first",                      default: "First?",           null: false
    t.string  "movie_rating",          limit: 50, default: "Rating"
    t.string  "movie_comment",         limit: 50, default: "Comment"
    t.string  "music_source",          limit: 50, default: "Source"
    t.string  "music_cost",            limit: 50, default: "Cost"
    t.string  "music_rating",          limit: 50, default: "Rating"
    t.string  "music_comment",         limit: 50, default: "Comment"
    t.string  "music_received",        limit: 50, default: "Received"
    t.string  "music_procurement",     limit: 50, default: "Procurement"
    t.string  "book_source",           limit: 50, default: "Source"
    t.string  "book_difficulty",       limit: 50, default: "Difficulty"
    t.string  "book_pagecount",        limit: 50, default: "Pagecount"
    t.string  "book_cost",             limit: 50, default: "Cost"
    t.string  "book_first",                       default: "First reading?",   null: false
    t.string  "book_rating",           limit: 50, default: "Rating"
    t.string  "book_comment",          limit: 50, default: "Comment"
    t.string  "concert_cost",          limit: 50, default: "Cost"
    t.string  "concert_rating",        limit: 50, default: "Rating"
    t.string  "concert_company",       limit: 50, default: "Company"
    t.string  "concert_comment",       limit: 50, default: "Comment"
    t.string  "event_cost",            limit: 50, default: "Cost"
    t.string  "event_rating",          limit: 50, default: "Rating"
    t.string  "event_company",         limit: 50, default: "Company"
    t.string  "event_comment",         limit: 50, default: "Comment"
    t.string  "restaurant_cost",       limit: 50, default: "Cost"
    t.string  "restaurant_cuisine",    limit: 50, default: "Cuisine"
    t.string  "restaurant_rating",     limit: 50, default: "Rating"
    t.string  "restaurant_comment",    limit: 50, default: "Comment"
    t.string  "restaurant_company",    limit: 50, default: "Company"
    t.string  "bar_cost",              limit: 50, default: "Cost"
    t.string  "bar_rating",            limit: 50, default: "Rating"
    t.string  "bar_company",           limit: 50, default: "Company"
    t.string  "bar_comment",           limit: 50, default: "Comment"
    t.string  "takeaway_cost",         limit: 50, default: "Cost"
    t.string  "takeaway_rating",       limit: 50, default: "Rating"
    t.string  "takeaway_company",      limit: 50, default: "Company"
    t.string  "takeaway_comment",      limit: 50, default: "Comment"
    t.string  "music_isnew",           limit: 50, default: "Isnew"
    t.string  "activity_company",      limit: 50, default: "Company"
    t.string  "activity_cost",         limit: 50, default: "Cost"
    t.string  "activity_rating",       limit: 50, default: "Rating"
    t.string  "activity_comment",      limit: 50, default: "Comment"
    t.string  "weight_comment",        limit: 50, default: "Comment"
    t.string  "loan_comment",          limit: 50, default: "Comment"
    t.string  "airport_comment",       limit: 50, default: "Comment"
    t.string  "airport_time_spent",    limit: 50, default: "Time spent"
    t.string  "project_name",          limit: 50, default: "Name"
    t.string  "project_format",        limit: 50, default: "Format"
    t.string  "project_materials",     limit: 50, default: "Materials"
    t.string  "project_tools",         limit: 50, default: "Tools"
    t.string  "project_collaborators", limit: 50, default: "Collaborators"
    t.string  "project_comment",       limit: 50, default: "Comment"
    t.string  "videogame_difficulty",  limit: 50, default: "Difficulty"
    t.string  "videogame_source",      limit: 50, default: "Source"
    t.string  "videogame_cost",        limit: 50, default: "Cost"
    t.string  "videogame_rating",      limit: 50, default: "Rating"
    t.string  "videogame_comment",     limit: 50, default: "Comment"
    t.string  "brewing_cost",          limit: 50, default: "Cost"
    t.string  "videogame_soldprice",   limit: 50, default: "Sold Price"
    t.string  "grocery_comment",       limit: 50, default: "Comments"
    t.string  "grocery_cost",          limit: 50, default: "Cost"
    t.string  "grocery_coupons",       limit: 50, default: "Coupons"
    t.string  "grocery_clubsavings",   limit: 50, default: "Club Savings"
    t.string  "tvseries_rating",                  default: "Rating"
    t.string  "tvseries_comment",                 default: "Comment"
    t.string  "mile_station",                     default: "Station"
    t.string  "mile_gasamount",                   default: "Amount"
    t.string  "mile_ppg",                         default: "Price per gallon"
    t.string  "mile_miles",                       default: "Miles"
    t.string  "mile_cost",                        default: "Cost"
    t.string  "mile_location",                    default: "Location"
  end

  create_table "weight", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.date     "date"
    t.float    "weight",      limit: 24
    t.text     "comment",     limit: 65535
    t.string   "userimage",   limit: 80
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.index ["currency_id"], name: "index_weight_on_currency_id", using: :btree
  end

  add_foreign_key "importbacklogs", "imports"
end
