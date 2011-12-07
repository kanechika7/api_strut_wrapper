概要
=====
- API用に最適化したControllerを自動生成するツールです。

機能一覧
--------
- controllerのresponseデータを、Modelで定義したカラムやメソッドに限定できます。
- requestのURLオプションにincludesを加えると、Railsの関連情報もまとめて取得できます。

依存関係
---------
* [strut] https://github.com/kuruma-gs/strut


使い方
------
① Controller 設定

  # 以下を設定（CRUD + copy）
  $ vi app/controllers/MODELS_controller.rb
  -----------------------------------------------------------
  class MODELS_controller < ApplicationController
    index_and_show_strut_wrapper Unit
  end
  -----------------------------------------------------------

  # ルーティング（使うものを定義）
  $ vi config/routes.rb
  -----------------------------------------------------------
  resources :units ,only: [:index,:show,:update,:destroy] do
    member do
      post :copy
    end
  end
  -----------------------------------------------------------



② Model 設定

  $ vi app/models/MODEL/scope.rb
  ----------------------------------------------------------- 
  class MODEL
    module Scope
      extend ActiveSupport::Concern
      include IndexAndShow::Document

      # index を取得するものを設定
      INDEX_SELECTS  = %w(id me)   # DBカラム
      INDEX_METHODS  = %w()        # メソッド
      # show を取得するものを設定
      SHOW_SELECTS   = %w(id me)   # DBカラム
      SHOW_METHODS   = %w()        # メソッド
      # copy 時にコピーするDBカラム
      COPYATTRIBUTES = %w(me)

      # クッキーから取得できるものを制限
      included do
        # for cookie
        scope :cookie_scope ,->(u){ where(unit_id: u.id) }
      end


    end
  end
  ----------------------------------------------------------- 





③ リクエスト
  - URL -
  GET    ./v1/objects.json           # index
  GET    ./v1/objects/:id.json       # show
  POST   ./v1/objects.json           # create
  PUT    ./v1/objects/:id.json       # update
  DELETE ./v1/objects/:id.json       # destroy
  POST   ./v1/objects/:id/copy.json  # copy


  - パラメータ -
  index、show にアクセスする時以下のパラメータが使用できる

  includes: 関連を取得、複数取得する時はカンマ（,）区切り、多段の時は「->(..)」で指定して取って来れる
    ex. 
      includes=unit
      includes=replies->(reply_answers,reply_integers)





