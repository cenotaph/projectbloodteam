# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141222191757) do

  create_table "activities", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date"
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address",  limit: 255
    t.string   "company",        limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "agents", force: :cascade do |t|
    t.string   "surname",                limit: 25
    t.integer  "age",                    limit: 4
    t.integer  "agent_since",            limit: 4
    t.string   "location",               limit: 25
    t.text     "missionname",            limit: 65535
    t.string   "encrypted_password",     limit: 128,   default: "",        null: false
    t.datetime "lastlogin",                                                null: false
    t.string   "role",                   limit: 12
    t.string   "username",               limit: 24
    t.string   "imageurl",               limit: 255
    t.boolean  "active",                 limit: 1,     default: false
    t.datetime "created"
    t.string   "headingsize",            limit: 5,     default: "0.9em"
    t.string   "rowsize",                limit: 5,     default: "0.8em"
    t.string   "defaultsort",            limit: 4,     default: "DESC",    null: false
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
    t.datetime "modified",                                                 null: false
    t.string   "email",                  limit: 80
    t.string   "lastfm",                 limit: 24
    t.integer  "theme_id",               limit: 4,     default: 1
    t.string   "twitname",               limit: 48
    t.string   "twitpasswd",             limit: 48
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.boolean  "email_notify",           limit: 1,     default: false,     null: false
    t.integer  "security",               limit: 4,     default: 0,         null: false
    t.string   "password_salt",          limit: 255,   default: "",        null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "slug",                   limit: 255
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "sign_in_count",          limit: 4
  end

  create_table "airports", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4,     null: false
    t.date     "date"
    t.string   "name",           limit: 255
    t.string   "code",           limit: 3
    t.string   "destination",    limit: 255
    t.integer  "time_spent",     limit: 4
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "bars", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                         null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "company",        limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "books", force: :cascade do |t|
    t.integer  "master_book_id", limit: 4
    t.integer  "agent_id",       limit: 4
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.string   "difficulty",     limit: 25
    t.integer  "pagecount",      limit: 4
    t.string   "source",         limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.integer  "label_id",       limit: 4
    t.text     "comment",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "first",          limit: 1,     default: true
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.string   "userimage",      limit: 255
  end

  add_index "books", ["agent_id"], name: "books_agent_idx", using: :btree
  add_index "books", ["agent_id"], name: "books_agents_idx", using: :btree

  create_table "brewing", force: :cascade do |t|
    t.date     "date"
    t.string   "product",        limit: 255
    t.string   "task",           limit: 255
    t.string   "company",        limit: 255
    t.string   "location",       limit: 255
    t.float    "cost",           limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 255
    t.boolean  "delta",          limit: 1
    t.integer  "currency_id",    limit: 4
    t.integer  "agent_id",       limit: 4
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geolocation_id", limit: 4
    t.string   "venue_address",  limit: 255
  end

  create_table "categories", force: :cascade do |t|
    t.integer "agent_id",    limit: 4
    t.integer "year",        limit: 4
    t.string  "movies",      limit: 50,  default: "Movies"
    t.string  "musics",      limit: 50,  default: "Music"
    t.string  "books",       limit: 50,  default: "Books"
    t.string  "restaurants", limit: 50,  default: "Restaurants"
    t.string  "bars",        limit: 50,  default: "Bars"
    t.string  "takeaway",    limit: 50,  default: "Takeaway"
    t.string  "concerts",    limit: 50,  default: "Concerts"
    t.string  "events",      limit: 50,  default: "Events"
    t.string  "eating",      limit: 50,  default: "Eating"
    t.string  "exercise",    limit: 50,  default: "Exercise"
    t.string  "weight",      limit: 50,  default: "Weight"
    t.string  "musicplayed", limit: 50,  default: "Music Played"
    t.string  "activities",  limit: 50,  default: "Activities"
    t.string  "gambling",    limit: 50,  default: "Gambling"
    t.string  "miles",       limit: 50,  default: "Mileage"
    t.string  "loans",       limit: 50,  default: "Loans"
    t.string  "airports",    limit: 50,  default: "Airports"
    t.string  "projects",    limit: 50,  default: "Projects"
    t.string  "videogames",  limit: 50,  default: "Video Games"
    t.string  "brewing",     limit: 50,  default: "Brewing"
    t.string  "tasks",       limit: 50,  default: "Tasks"
    t.string  "groceries",   limit: 50,  default: "Groceries"
    t.string  "tvseries",    limit: 255, default: "TV Series"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "item_type",  limit: 48
    t.integer  "foreign_id", limit: 4,     null: false
    t.text     "content",    limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id",   limit: 4
    t.boolean  "delta",      limit: 1
  end

  create_table "concerts", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                         null: false
    t.text     "artists",        limit: 65535
    t.string   "venue",          limit: 64
    t.string   "venue_address",  limit: 255
    t.float    "cost",           limit: 24
    t.string   "company",        limit: 255
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  add_index "concerts", ["agent_id"], name: "concerts_agent_idx", using: :btree
  add_index "concerts", ["agent_id"], name: "concerts_agents_idx", using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string   "name",      limit: 32
    t.string   "code",      limit: 3
    t.string   "symbol",    limit: 12
    t.datetime "created"
    t.datetime "modified"
    t.boolean  "unitafter", limit: 1,  default: false, null: false
  end

  create_table "eating", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
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
    t.integer  "supplementsnum", limit: 4
    t.integer  "label_id",       limit: 4
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.boolean  "delta",          limit: 1
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4
    t.integer  "entry_id",   limit: 4
    t.string   "entry_type", limit: 255
    t.string   "action",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                                     null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address",  limit: 255
    t.string   "company",        limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  add_index "events", ["agent_id"], name: "events_agent_idx", using: :btree

  create_table "exchanges", force: :cascade do |t|
    t.integer  "basecurrency_id",  limit: 4
    t.integer  "othercurrency_id", limit: 4
    t.boolean  "entire_year",      limit: 1
    t.date     "sample_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rate",             limit: 53
  end

  create_table "exercise", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4
    t.date     "date"
    t.text     "activity",   limit: 65535
    t.float    "hours",      limit: 24
    t.integer  "label_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "distance",   limit: 24
    t.integer  "sets",       limit: 4
    t.integer  "reps",       limit: 4
    t.text     "comment",    limit: 65535
    t.string   "userimage",  limit: 80
    t.boolean  "delta",      limit: 1
  end

  create_table "favoritemovies", force: :cascade do |t|
    t.integer  "agent_id",        limit: 4
    t.integer  "master_movie_id", limit: 4
    t.float    "ranking",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4
    t.string   "subject",    limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "delta",      limit: 1
    t.string   "slug",       limit: 255
  end

  create_table "gambling", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                         null: false
    t.string   "name",           limit: 255
    t.string   "location",       limit: 255
    t.text     "games",          limit: 65535
    t.float    "profit",         limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.float    "rating",         limit: 24
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "geolocations", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.float    "latitude",   limit: 53
    t.float    "longitude",  limit: 53
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groceries", force: :cascade do |t|
    t.date     "date"
    t.string   "name",           limit: 255
    t.string   "location",       limit: 255
    t.float    "cost",           limit: 24
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 255
    t.boolean  "delta",          limit: 1
    t.integer  "currency_id",    limit: 4
    t.integer  "agent_id",       limit: 4
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "coupons",        limit: 24
    t.float    "clubsavings",    limit: 24
    t.integer  "geolocation_id", limit: 4
  end

  create_table "import_books", force: :cascade do |t|
    t.integer  "master_book_id", limit: 4
    t.integer  "agent_id",       limit: 4
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.text     "author",         limit: 65535
    t.text     "title",          limit: 65535
    t.text     "source",         limit: 65535
    t.string   "currency",       limit: 8
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.boolean  "first",          limit: 1
    t.text     "comments",       limit: 65535
    t.datetime "created",                      null: false
    t.string   "difficulty",     limit: 25
    t.integer  "pagecount",      limit: 4
  end

  create_table "import_movies", force: :cascade do |t|
    t.integer  "master_movie_id", limit: 4
    t.integer  "agent_id",        limit: 4
    t.text     "title",           limit: 65535
    t.date     "date"
    t.string   "location",        limit: 64
    t.string   "format",          limit: 15
    t.text     "company",         limit: 65535
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.integer  "label_id",        limit: 4
    t.text     "comment",         limit: 65535
    t.datetime "created",                       null: false
    t.date     "started"
  end

  create_table "import_musics", force: :cascade do |t|
    t.integer  "master_music_id", limit: 4
    t.integer  "agent_id",        limit: 4
    t.date     "date"
    t.text     "artist",          limit: 65535
    t.text     "title",           limit: 65535
    t.text     "label",           limit: 65535
    t.string   "format",          limit: 255
    t.string   "source",          limit: 32
    t.string   "currency",        limit: 8
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.text     "comments",        limit: 65535
    t.datetime "created",                       null: false
  end

  create_table "import_restaurants", force: :cascade do |t|
    t.integer  "agent_id", limit: 4
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
    t.datetime "created",                null: false
  end

  create_table "imports", force: :cascade do |t|
    t.integer  "agent_id",            limit: 4
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size",    limit: 4
    t.datetime "upload_updated_at"
    t.string   "category",            limit: 255
    t.boolean  "finished",            limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4
    t.string   "name",       limit: 128
    t.text     "comment",    limit: 65535
    t.string   "bgcolor",    limit: 7
    t.string   "textcolor",  limit: 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", force: :cascade do |t|
    t.integer  "agent_id",    limit: 4,                    null: false
    t.date     "date"
    t.date     "ended"
    t.boolean  "is_out",      limit: 1,     default: true, null: false
    t.string   "name",        limit: 255,                  null: false
    t.string   "material",    limit: 80
    t.string   "other_party", limit: 80,                   null: false
    t.text     "comment",     limit: 65535
    t.integer  "label_id",    limit: 4
    t.string   "userimage",   limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",       limit: 1
  end

  create_table "master_books", force: :cascade do |t|
    t.string   "amazoncode",            limit: 255
    t.text     "author",                limit: 65535
    t.text     "title",                 limit: 65535
    t.integer  "uses",                  limit: 4,     default: 0
    t.datetime "created",                                         null: false
    t.string   "filename_file_name",    limit: 255
    t.integer  "filename_file_size",    limit: 4
    t.string   "filename_content_type", limit: 255
    t.integer  "height",                limit: 4
    t.integer  "width",                 limit: 4
    t.datetime "filename_updated_at"
  end

  create_table "master_movies", force: :cascade do |t|
    t.integer  "imdbcode",              limit: 4
    t.text     "title",                 limit: 65535
    t.text     "director",              limit: 65535
    t.integer  "year",                  limit: 4
    t.text     "country",               limit: 65535
    t.integer  "uses",                  limit: 4,     default: 0
    t.datetime "created_at"
    t.string   "filename_file_name",    limit: 255
    t.integer  "filename_file_size",    limit: 4
    t.string   "filename_content_type", limit: 255
    t.integer  "height",                limit: 4
    t.integer  "width",                 limit: 4
    t.datetime "filename_updated_at"
    t.boolean  "delta",                 limit: 1
  end

  create_table "master_musics", force: :cascade do |t|
    t.integer  "discogscode",           limit: 4
    t.text     "artist",                limit: 65535
    t.text     "title",                 limit: 65535
    t.integer  "year",                  limit: 4
    t.string   "label",                 limit: 64
    t.string   "format",                limit: 64
    t.integer  "uses",                  limit: 4,     default: 0
    t.datetime "created",                                             null: false
    t.string   "filename_file_name",    limit: 255
    t.integer  "filename_file_size",    limit: 4
    t.string   "filename_content_type", limit: 255
    t.integer  "height",                limit: 4
    t.integer  "width",                 limit: 4
    t.datetime "filename_updated_at"
    t.integer  "masterdiscogs_id",      limit: 4
    t.boolean  "converted",             limit: 1,     default: false, null: false
  end

  create_table "master_tvseries", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.integer  "year",               limit: 4
    t.string   "image_file_name",    limit: 255
    t.integer  "image_file_size",    limit: 4
    t.string   "image_content_type", limit: 255
    t.integer  "height",             limit: 4
    t.integer  "width",              limit: 4
    t.datetime "image_updated_at"
    t.boolean  "delta",              limit: 1
    t.string   "slug",               limit: 255
    t.integer  "imdbcode",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "master_videogames", force: :cascade do |t|
    t.string   "amazoncode",            limit: 255
    t.string   "title",                 limit: 255
    t.string   "creator",               limit: 255
    t.string   "platform",              limit: 255
    t.string   "filename_file_name",    limit: 255
    t.integer  "filename_file_size",    limit: 4
    t.string   "filename_content_type", limit: 255
    t.integer  "height",                limit: 4
    t.integer  "width",                 limit: 4
    t.datetime "filename_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "miles", force: :cascade do |t|
    t.integer  "agent_id",    limit: 4
    t.date     "date",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "station",     limit: 50
    t.string   "location",    limit: 100
    t.float    "cost",        limit: 24
    t.float    "gasamount",   limit: 24
    t.float    "ppg",         limit: 24
    t.float    "miles",       limit: 24
    t.integer  "label_id",    limit: 4
    t.integer  "currency_id", limit: 4
    t.text     "comment",     limit: 65535
    t.string   "userimage",   limit: 80
    t.boolean  "delta",       limit: 1
  end

  create_table "movies", force: :cascade do |t|
    t.integer  "master_movie_id", limit: 4
    t.integer  "agent_id",        limit: 4
    t.date     "started"
    t.date     "date"
    t.string   "location",        limit: 64
    t.string   "venue_address",   limit: 255
    t.string   "format",          limit: 150
    t.string   "company",         limit: 255
    t.float    "cost",            limit: 24
    t.float    "rating",          limit: 24
    t.integer  "label_id",        limit: 4
    t.text     "comment",         limit: 65535
    t.datetime "created_at"
    t.boolean  "is_short",        limit: 1,     default: false
    t.datetime "updated_at"
    t.boolean  "first",           limit: 1,     default: true
    t.integer  "currency_id",     limit: 4
    t.boolean  "delta",           limit: 1
    t.string   "userimage",       limit: 255
    t.integer  "geolocation_id",  limit: 4
  end

  add_index "movies", ["agent_id"], name: "movie_agent_idx", using: :btree

  create_table "musicplayed", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date"
    t.text     "company",        limit: 65535
    t.text     "location",       limit: 65535
    t.string   "venue_address",  limit: 255
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_id",       limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "musics", force: :cascade do |t|
    t.integer  "master_music_id", limit: 4
    t.integer  "agent_id",        limit: 4
    t.date     "date"
    t.datetime "created_at"
    t.float    "cost",            limit: 24
    t.string   "source",          limit: 255
    t.float    "rating",          limit: 24
    t.integer  "label_id",        limit: 4
    t.text     "comment",         limit: 65535
    t.date     "received"
    t.integer  "procurement",     limit: 1,     default: 0
    t.datetime "updated_at"
    t.boolean  "isnew",           limit: 1
    t.integer  "currency_id",     limit: 4
    t.boolean  "delta",           limit: 1
    t.string   "userimage",       limit: 255
  end

  add_index "musics", ["agent_id"], name: "musics_agent_idx", using: :btree

  create_table "newsfeed", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4,  null: false
    t.integer  "foreign_id", limit: 4,  null: false
    t.string   "category",   limit: 40
    t.string   "action",     limit: 10
    t.datetime "time"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "agent_id", limit: 4,     null: false
    t.text     "post",     limit: 65535
    t.datetime "created",                null: false
    t.string   "subject",  limit: 64
  end

  create_table "profiles", id: false, force: :cascade do |t|
    t.integer  "id",                  limit: 4,                          null: false
    t.integer  "agent_id",            limit: 4,                          null: false
    t.integer  "year",                limit: 4,                          null: false
    t.string   "surname",             limit: 50,                         null: false
    t.integer  "age",                 limit: 4
    t.string   "location",            limit: 50
    t.string   "missionname",         limit: 255,                        null: false
    t.string   "imageurl",            limit: 255
    t.boolean  "active",              limit: 1,     default: false,      null: false
    t.integer  "defaultcurrency_id",  limit: 4,     default: 1,          null: false
    t.string   "dateformat",          limit: 16,    default: "%Y-%m-%d", null: false
    t.integer  "theme_id",            limit: 4,     default: 1,          null: false
    t.text     "freetext",            limit: 65535
    t.string   "ratingscale",         limit: 25
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "customrss",           limit: 65535
    t.boolean  "showtwitter",         limit: 1,     default: true,       null: false
    t.string   "delicious",           limit: 40
    t.string   "deliciouspw",         limit: 40
    t.string   "avatar_file_name",    limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.string   "avatar_content_type", limit: 255
    t.datetime "avatar_updated_at"
    t.text     "theme_settings",      limit: 65535
    t.boolean  "shortfilms",          limit: 1
  end

  add_index "profiles", ["year", "agent_id"], name: "year", unique: true, using: :btree

  create_table "profiles_themes", force: :cascade do |t|
    t.integer  "profile_id", limit: 4,     null: false
    t.integer  "theme_id",   limit: 4,     null: false
    t.text     "settings",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "agent_id",      limit: 4,                     null: false
    t.date     "date"
    t.date     "ended"
    t.string   "name",          limit: 255
    t.string   "format",        limit: 255
    t.string   "materials",     limit: 255
    t.string   "tools",         limit: 255
    t.string   "collaborators", limit: 255
    t.text     "comment",       limit: 65535
    t.string   "userimage",     limit: 80
    t.integer  "label_id",      limit: 4
    t.boolean  "priv",          limit: 1,     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",         limit: 1
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                         null: false
    t.string   "name",           limit: 128
    t.string   "location",       limit: 64
    t.string   "company",        limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.string   "cuisine",        limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  add_index "restaurants", ["agent_id"], name: "restaurants_agents_idx", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255
    t.text     "data",       limit: 16777215
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "takeaway", force: :cascade do |t|
    t.integer  "agent_id",       limit: 4
    t.date     "date",                         null: false
    t.text     "name",           limit: 65535
    t.text     "location",       limit: 65535
    t.string   "company",        limit: 255
    t.float    "cost",           limit: 24
    t.float    "rating",         limit: 24
    t.text     "ordered",        limit: 65535
    t.text     "comment",        limit: 65535
    t.string   "userimage",      limit: 80
    t.integer  "label_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",    limit: 4
    t.boolean  "delta",          limit: 1
    t.integer  "geolocation_id", limit: 4
  end

  create_table "themes", force: :cascade do |t|
    t.string   "name",        limit: 24
    t.text     "description", limit: 65535
    t.boolean  "active",      limit: 1,     default: false
    t.datetime "created"
    t.datetime "modified"
    t.text     "defaultcss",  limit: 65535
  end

  create_table "tvseries", force: :cascade do |t|
    t.integer  "agent_id",           limit: 4
    t.integer  "master_tvseries_id", limit: 4
    t.date     "started"
    t.date     "finished"
    t.integer  "season",             limit: 4
    t.float    "rating",             limit: 24
    t.text     "comment",            limit: 65535
    t.boolean  "first",              limit: 1
    t.string   "userimage",          limit: 255
    t.string   "location",           limit: 255
    t.string   "venue_address",      limit: 255
    t.integer  "geolocation_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tvseries", ["agent_id"], name: "index_tvseries_on_agent_id", using: :btree
  add_index "tvseries", ["geolocation_id"], name: "index_tvseries_on_geolocation_id", using: :btree
  add_index "tvseries", ["master_tvseries_id"], name: "index_tvseries_on_master_tvseries_id", using: :btree

  create_table "userimages", force: :cascade do |t|
    t.integer  "entry_id",           limit: 4
    t.string   "entry_type",         limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.boolean  "primary",            limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_remote_url",   limit: 255
  end

  create_table "videogames", force: :cascade do |t|
    t.integer  "master_videogame_id", limit: 4,     null: false
    t.integer  "agent_id",            limit: 4
    t.date     "received"
    t.date     "started"
    t.date     "finished"
    t.string   "difficulty",          limit: 255
    t.string   "source",              limit: 255
    t.float    "cost",                limit: 24
    t.float    "rating",              limit: 24
    t.integer  "label_id",            limit: 4
    t.text     "comment",             limit: 65535
    t.boolean  "first",               limit: 1
    t.integer  "currency_id",         limit: 4
    t.boolean  "delta",               limit: 1
    t.string   "userimage",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "soldprice",           limit: 24
  end

  create_table "views", force: :cascade do |t|
    t.integer "agent_id",              limit: 4
    t.integer "year",                  limit: 4,                             null: false
    t.string  "movie_started",         limit: 50,  default: "Started"
    t.string  "movie_format",          limit: 50,  default: "Format"
    t.string  "movie_location",        limit: 5
    t.string  "movie_company",         limit: 50,  default: "Company"
    t.string  "movie_cost",            limit: 50,  default: "Cost"
    t.string  "movie_first",           limit: 5
    t.string  "movie_rating",          limit: 50,  default: "Rating"
    t.string  "movie_comment",         limit: 50,  default: "Comment"
    t.string  "music_source",          limit: 50,  default: "Source"
    t.string  "music_cost",            limit: 50,  default: "Cost"
    t.string  "music_rating",          limit: 50,  default: "Rating"
    t.string  "music_comment",         limit: 50,  default: "Comment"
    t.string  "music_received",        limit: 50,  default: "Received"
    t.string  "music_procurement",     limit: 50,  default: "Procurement"
    t.string  "book_source",           limit: 50,  default: "Source"
    t.string  "book_difficulty",       limit: 50,  default: "Difficulty"
    t.string  "book_pagecount",        limit: 50,  default: "Pagecount"
    t.string  "book_cost",             limit: 50,  default: "Cost"
    t.string  "book_first",            limit: 5
    t.string  "book_rating",           limit: 50,  default: "Rating"
    t.string  "book_comment",          limit: 50,  default: "Comment"
    t.string  "concert_cost",          limit: 50,  default: "Cost"
    t.string  "concert_rating",        limit: 50,  default: "Rating"
    t.string  "concert_company",       limit: 50,  default: "Company"
    t.string  "concert_comment",       limit: 50,  default: "Comment"
    t.string  "event_cost",            limit: 50,  default: "Cost"
    t.string  "event_rating",          limit: 50,  default: "Rating"
    t.string  "event_company",         limit: 50,  default: "Company"
    t.string  "event_comment",         limit: 50,  default: "Comment"
    t.string  "restaurant_cost",       limit: 50,  default: "Cost"
    t.string  "restaurant_cuisine",    limit: 50,  default: "Cuisine"
    t.string  "restaurant_rating",     limit: 50,  default: "Rating"
    t.string  "restaurant_comment",    limit: 50,  default: "Comment"
    t.string  "restaurant_company",    limit: 50,  default: "Company"
    t.string  "bar_cost",              limit: 50,  default: "Cost"
    t.string  "bar_rating",            limit: 50,  default: "Rating"
    t.string  "bar_company",           limit: 50,  default: "Company"
    t.string  "bar_comment",           limit: 50,  default: "Comment"
    t.string  "takeaway_cost",         limit: 50,  default: "Cost"
    t.string  "takeaway_rating",       limit: 50,  default: "Rating"
    t.string  "takeaway_company",      limit: 50,  default: "Company"
    t.string  "takeaway_comment",      limit: 50,  default: "Comment"
    t.string  "music_isnew",           limit: 50,  default: "Isnew"
    t.string  "activity_company",      limit: 50,  default: "Company"
    t.string  "activity_cost",         limit: 50,  default: "Cost"
    t.string  "activity_rating",       limit: 50,  default: "Rating"
    t.string  "activity_comment",      limit: 50,  default: "Comment"
    t.string  "weight_comment",        limit: 50,  default: "Comment"
    t.string  "loan_comment",          limit: 50,  default: "Comment"
    t.string  "airport_comment",       limit: 50,  default: "Comment"
    t.string  "airport_time_spent",    limit: 50,  default: "Time spent"
    t.string  "project_name",          limit: 50,  default: "Name"
    t.string  "project_format",        limit: 50,  default: "Format"
    t.string  "project_materials",     limit: 50,  default: "Materials"
    t.string  "project_tools",         limit: 50,  default: "Tools"
    t.string  "project_collaborators", limit: 50,  default: "Collaborators"
    t.string  "project_comment",       limit: 50,  default: "Comment"
    t.string  "videogame_difficulty",  limit: 50,  default: "Difficulty"
    t.string  "videogame_source",      limit: 50,  default: "Source"
    t.string  "videogame_cost",        limit: 50,  default: "Cost"
    t.string  "videogame_rating",      limit: 50,  default: "Rating"
    t.string  "videogame_comment",     limit: 50,  default: "Comment"
    t.string  "brewing_cost",          limit: 50,  default: "Cost"
    t.string  "videogame_soldprice",   limit: 50,  default: "Sold Price"
    t.string  "grocery_comment",       limit: 50,  default: "Comments"
    t.string  "grocery_cost",          limit: 50,  default: "Cost"
    t.string  "grocery_coupons",       limit: 50,  default: "Coupons"
    t.string  "grocery_clubsavings",   limit: 50,  default: "Club Savings"
    t.string  "tvseries_rating",       limit: 255, default: "Rating"
    t.string  "tvseries_comment",      limit: 255, default: "Comment"
  end

  create_table "weight", force: :cascade do |t|
    t.integer  "agent_id",   limit: 4
    t.date     "date"
    t.float    "weight",     limit: 24
    t.text     "comment",    limit: 65535
    t.string   "userimage",  limit: 80
    t.integer  "label_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
