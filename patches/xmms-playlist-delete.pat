--- ./libxmms/xmmsctrl.c.orig	Wed Jun 16 12:51:13 1999
+++ ./libxmms/xmmsctrl.c	Sat Jun 26 12:05:57 1999
@@ -266,6 +266,11 @@
 	g_free(str_list);
 }
 
+void xmms_remote_playlist_delete(gint session,gint pos)
+{
+	remote_send_guint32(session,CMD_PLAYLIST_DELETE,pos);
+}
+
 void xmms_remote_play(gint session)
 {
 	remote_cmd(session, CMD_PLAY);
--- ./libxmms/xmmsctrl.h.orig	Wed Jun 16 12:51:13 1999
+++ ./libxmms/xmmsctrl.h	Sat Jun 26 12:05:57 1999
@@ -24,6 +24,7 @@
 void xmms_remote_playlist(gint session, gchar ** list, gint num, gboolean enqueue);
 gint xmms_remote_get_version(gint session);
 void xmms_remote_playlist_add(gint session, GList * list);
+void xmms_remote_playlist_delete(gint session, gint pos);
 void xmms_remote_play(gint session);
 void xmms_remote_pause(gint session);
 void xmms_remote_stop(gint session);
--- ./xmms/controlsocket.h.orig	Wed Jun 16 12:51:15 1999
+++ ./xmms/controlsocket.h	Sat Jun 26 12:06:11 1999
@@ -27,7 +27,7 @@
 
 enum
 {
-	CMD_GET_VERSION, CMD_PLAYLIST_ADD, CMD_PLAY, CMD_PAUSE, CMD_STOP,
+	CMD_GET_VERSION, CMD_PLAYLIST_ADD, CMD_PLAYLIST_DELETE, CMD_PLAY, CMD_PAUSE, CMD_STOP,
 	CMD_IS_PLAYING, CMD_IS_PAUSED, CMD_GET_PLAYLIST_POS,
 	CMD_SET_PLAYLIST_POS, CMD_GET_PLAYLIST_LENGTH, CMD_PLAYLIST_CLEAR,
 	CMD_GET_OUTPUT_TIME, CMD_JUMP_TO_TIME, CMD_GET_VOLUME,
--- ./xmms/controlsocket.c.orig	Wed Jun 16 12:51:15 1999
+++ ./xmms/controlsocket.c	Sat Jun 26 12:06:11 1999
@@ -341,6 +341,20 @@
 						playlistwin_update_list();
 						ctrl_ack_packet(pkt);
 						break;
+ 					case	CMD_PLAYLIST_DELETE:
+ 						pthread_mutex_lock(&playlist_mutex);
+ 					        if (data && get_playlist_length()) {
+ 						    GList *node = g_list_nth(get_playlist(), *((guint32 *)data));
+ 						    if (node) {
+ 							PlaylistEntry *entry = (PlaylistEntry *)node->data;
+ 							entry->selected = 1;
+ 							pthread_mutex_unlock(&playlist_mutex);
+ 							playlist_delete(0);
+ 						    }
+ 						}
+ 						pthread_mutex_unlock(&playlist_mutex);
+ 						ctrl_ack_packet(pkt);
+ 						break;
 					case CMD_PLAYLIST_CLEAR:
 						playlist_clear();
 						ctrl_ack_packet(pkt);
