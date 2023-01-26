CREATE SEQUENCE SEQ_REPLY;

CREATE TABLE TBL_FOLLOW(
   FOLLOW_ID NUMBER CONSTRAINT PK_FOLLOW PRIMARY KEY,
   FOLLOWING_ID NUMBER NOT NULL,
   FOLLOWER_ID NUMBER NOT NULL,
   CONSTRAINT FK_FOLLOWING_USER FOREIGN KEY(FOLLOWING_ID) REFERENCES TBL_USER(USER_ID) ON DELETE CASCADE,
   CONSTRAINT FK_FOLLOWER_USER FOREIGN KEY(FOLLOWER_ID) REFERENCES TBL_USER(USER_ID) ON DELETE CASCADE
);

DROP TABLE TBL_FOLLOW;
SELECT * FROM TBL_FOLLOW;